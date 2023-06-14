class GccStrap < Formula
  desc "GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-13.1.0/gcc-13.1.0.tar.xz"
  sha256 "61d684f0aa5e76ac6585ad8898a2427aade8979ed5e7f85492286c4dfc13ee86"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/gcc-strap-13.1.0"
    sha256 ventura: "82e96df774d5593f3f72bd4d1d593d46085cf505da947a0d65cf79c5e04128a0"
  end

  keg_only "bootstrap formula"

  depends_on "doxygen"  => :build
  depends_on "gcc-boot" => :build
  depends_on "gettext"  => :build
  depends_on "python"   => :build
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

    triple = "#{Hardware::CPU.arch}-apple-#{OS.kernel_name.downcase}"
    languages = %w[ada c c++ d objc obj-c++ fortran jit lto m2]
    sr = MacOS.sdk_path.to_str.tr "0-9", ""

    configure_args = %W[
      --build=#{triple}
      --prefix=#{prefix}
      --disable-bootstrap
      --disable-multilib
      --enable-checking=release
      --enable-libphobos
      --enable-languages=#{languages.join(",")}
      --with-gcc-major-version-only
      --with-sysroot=#{sr}
      --with-arch=x86-64
      --with-tune=generic
    ]

    system "./contrib/download_prerequisites"
    mkdir "build" do
      system "../configure", *configure_args
      system "make"
      system "make", "install", "-j", "1"
      system "make", "-C", "gcc", "install-man", "install-info", "-j", "1"

      # make libstdc++ documentation
      system "make", "-C", "#{triple}/libstdc++-v3/doc", "prefix=#{prefix}", "doc-man-doxygen"
      system "make", "-C", "#{triple}/libstdc++-v3/doc", "prefix=#{prefix}", "doc-install-man"
      system "make", "-C", "#{triple}/libstdc++-v3/po", "prefix=#{prefix}", "install"
    end
    rm_rf man3/"stdheader.dSYM"
    [info, man1, man3, man7].each { |d| Utils::Gzip.compress(*Dir[d/"*"]) }
    MachO::Tools.add_rpath "#{lib}/gcc/#{triple}/#{version.major}/adalib/#{shared_library "libgnarl"}",
                           "@loader_path"
  end

  test do
    system "echo"
  end
end
