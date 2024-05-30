class Arm64AppleDarwinGcc < Formula
  desc "GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-14.1.0/gcc-14.1.0.tar.xz"
  sha256 "e283c654987afe3de9d8080bc0bd79534b5ca0d681a73a11ff2b5d3767426840"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/gcc-boot-14.1.0"
    sha256 ventura: "4775fb895ade05fcf3996e47fd3619f4e8b4f987c08b7444a59fe2aff6db6358"
  end

  keg_only "bootstrap formula"

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

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/82b5c1cd38826ab67ac7fc498a8fe74376a40f4a/gcc/gcc-14.1.0.diff"
    sha256 "1529cff128792fe197ede301a81b02036c8168cb0338df21e4bc7aafe755305a"
  end

  def install
    ENV.prepend_path "PATH", Formula["gcc-strap"].bin
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
      --host=#{triple}
      --target=#{target}
      --prefix=#{prefix}
      --program-prefix=#{target}-
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

    mkdir "tgt_bin" do
      %w[ar nm dsymutil strip lipo].each do |t|
        ln_s "#{sr}/../../usr/bin/#{t}", "#{target}-#{t}"
        bin.install_symlink "#{sr}/../../usr/bin/#{t}" => "#{target}-#{t}"
      end
      [Pathname.pwd, bin].each do |p|
        (p/"#{target}-ranlib").write <<~SH
          #! /bin/sh
          ranlib "$@"
        SH
        chmod "+x", p/"#{target}-ranlib"
      end
    end
    ENV.prepend_path "PATH", buildpath/"tgt_bin"

    system "./contrib/download_prerequisites"
    mkdir "build" do
      system "../configure", *configure_args
      system "gmake"
      system "gmake", "install", "-j", "1"
    end
    rm_rf man3/"stdheader.dSYM"
    [info, man1, man3, man7].each { |d| Utils::Gzip.compress(*Dir[d/"*"]) }
  end

  test do
    system "echo"
  end
end
