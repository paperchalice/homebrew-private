class BootstrapGcc < Formula
  desc "GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-14.1.0/gcc-14.1.0.tar.xz"
  sha256 "e283c654987afe3de9d8080bc0bd79534b5ca0d681a73a11ff2b5d3767426840"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/bootstrap-gcc-14.1.0"
    sha256 cellar: :any_skip_relocation, ventura: "5eda04ad565adc2ac872f4e11ec87aacbee2f12b00b43fd6df422b3958000a7a"
  end

  keg_only "bootstrap formula"

  depends_on "arm64-apple-darwin-gcc" => :build
  depends_on "doxygen"   => :build
  depends_on "gcc-strap" => :build
  depends_on "gettext"   => :build
  depends_on "make"      => :build
  depends_on "python"    => :build
  depends_on "rust"      => :build
  depends_on "texinfo"   => :build
  depends_on xcode: :build

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

  resource "isl" do
    url "https://libisl.sourceforge.io/isl-0.26.tar.xz"
    sha256 "a0b5cb06d24f9fa9e77b55fabbe9a3c94a336190345c2555f9915bb38e976504"
  end

  resource "mpc" do
    url "https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz"
    sha256 "ab642492f5cf882b74aa0cb730cd410a81edcdbec895183ce930e706c1c759b8"
  end

  resource "mpfr" do
    url "https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.1.tar.xz"
    sha256 "277807353a6726978996945af13e52829e3abd7a9a5b7fb2793894e18f1fcbb2"
  end

  resource "gmp" do
    url "https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz"
    sha256 "a3c2b80201b89e68616f4ad30bc66aee4927c3ce50e33929ca819d5c43538898"
  end

  resource "gettext" do
    url "https://ftp.gnu.org/gnu/gettext/gettext-0.22.5.tar.gz"
    sha256 "ec1705b1e969b83a9f073144ec806151db88127f5e40fe5a94cb6c8fa48996a0"
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/82b5c1cd38826ab67ac7fc498a8fe74376a40f4a/gcc/gcc-14.1.0.diff"
    sha256 "1529cff128792fe197ede301a81b02036c8168cb0338df21e4bc7aafe755305a"
  end

  def install
    ENV.delete "CC"
    ENV.delete "CXX"
    ENV.delete "LD"

    inreplace "libgcc/config/t-darwin-min-5", "10.5", "11.7"

    triple = "#{Hardware::CPU.arch}-apple-darwin#{OS.kernel_version.major}"
    target = "arm64-apple-darwin#{OS.kernel_version.major}"
    languages = %w[ada c c++ d]
    sr = MacOS.sdk_path.to_str.tr "0-9", ""

    configure_args = %W[
      --build=#{triple}
      --host=#{target}
      --target=#{target}
      --prefix=#{prefix}
      --with-as=/usr/bin/as
      --with-ld=/usr/bin/ld
      --with-dsymutil=/usr/bin/dsymutil
      --disable-bootstrap
      --disable-multilib
      --enable-checking=release
      --enable-languages=#{languages.join(",")}
      --with-gcc-major-version-only
      --with-sysroot=#{sr}
      --without-zstd
    ]

    resources.each { |r| r.stage buildpath/r.name }
    mkdir "build" do
      system "../configure", *configure_args
      system "gmake"
      system "gmake", "install", "-j", "1"
    end

    cross = Formula["arm64-apple-darwin-gcc"]
    gcc_s = (cross.prefix/"#{target}/lib"/shared_library("libgcc_s", "1.1")).to_s
    gcc_ss = (lib/shared_library("libgcc_s", "1.1")).to_s
    Pathname.glob(lib/"gcc/#{target}/#{version.major}/adalib"/shared_library("*")).each do |l|
      d = MachO::Tools.dylibs l
      MachO::Tools.change_install_name l.to_s, gcc_s, gcc_ss if d.include? gcc_s
    end

    libstdcxx = lib/shared_library("libstdc++", "6")
    rm libstdcxx
    cp cross.prefix/"#{target}/lib"/shared_library("libstdc++", "6"), libstdcxx
    MachO::Tools.change_dylib_id libstdcxx.to_s, libstdcxx.to_s

    system "tar", "-cJf", "gcc.tar.xz", "-C", prefix, "."
    rm_r prefix
    prefix.install "gcc.tar.xz"
  end

  test do
    system "echo"
  end
end
