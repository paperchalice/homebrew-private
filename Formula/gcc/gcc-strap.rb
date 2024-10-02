class GccStrap < Formula
  desc "GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-14.1.0/gcc-14.1.0.tar.xz"
  sha256 "e283c654987afe3de9d8080bc0bd79534b5ca0d681a73a11ff2b5d3767426840"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/gcc-strap-14.1.0"
    sha256 ventura: "b1dd12d40c2d432a23ef75f31d54c66c7819293ad5f6fe200e31709332dc5124"
  end

  keg_only "bootstrap formula"

  depends_on "doxygen"  => :build
  depends_on "gcc-boot" => :build
  depends_on "gettext"  => :build
  depends_on "make"     => :build
  depends_on "python"   => :build
  depends_on "rust"     => :build
  depends_on "texinfo"  => :build

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

  def install
    ENV.prepend_path "PATH", Formula["gcc-boot"].bin
    ENV.delete "CC"
    ENV.delete "CXX"
    ENV.delete "LD"

    inreplace "libgcc/config/t-darwin-min-5", "10.5", "11.7"

    triple = "#{Hardware::CPU.arch}-apple-darwin#{OS.kernel_version.major}"
    languages = %w[ada c c++ d objc obj-c++ fortran jit lto m2 rust]
    sr = MacOS.sdk_path.to_str.tr "0-9", ""

    configure_args = %W[
      --build=#{triple}
      --prefix=#{prefix}
      --disable-multilib
      --disable-bootstrap
      --enable-checking=release
      --enable-libphobos
      --enable-languages=#{languages.join(",")}
      --with-gcc-major-version-only
      --with-sysroot=#{sr}
      --with-arch=x86-64
      --with-tune=generic
      --without-zstd
    ]

    system "./contrib/download_prerequisites"
    mkdir "build" do
      system "../configure", *configure_args
      system "gmake"
      system "gmake", "install", "-j", "1"
      system "gmake", "-C", "gcc", "install-man", "install-info", "-j", "1"

      # make libstdc++ documentation
      system "gmake", "-C", "#{triple}/libstdc++-v3/doc", "prefix=#{prefix}", "doc-man-doxygen"
      system "gmake", "-C", "#{triple}/libstdc++-v3/doc", "prefix=#{prefix}", "doc-install-man"
      system "gmake", "-C", "#{triple}/libstdc++-v3/po", "prefix=#{prefix}", "install"
    end
    rm_r man3/"stdheader.dSYM"
    [info, man1, man3, man7].each { |d| Utils::Gzip.compress(*Dir[d/"*"]) }

    gcc_s = (Formula["gcc-boot"].lib/shared_library("libgcc_s", "1.1")).to_s
    gcc_ss = (lib/shared_library("libgcc_s", "1.1")).to_s
    MachO::Tools.add_rpath "#{lib}/#{shared_library "libgcc_s", 1}", "@loader_path"
    (Pathname.glob(lib/shared_library("*")) +
      Pathname.glob(lib/"gcc/#{triple}/#{version.major}/adalib"/shared_library("*"))).each do |l|
      d = MachO::Tools.dylibs l
      MachO::Tools.change_install_name l.to_s, gcc_s, gcc_ss if d.include? gcc_s
    end
  end

  test do
    system "echo"
  end
end
