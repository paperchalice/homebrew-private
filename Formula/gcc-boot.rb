class GccBoot < Formula
  desc "GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz"
  sha256 "e275e76442a6067341a27f04c5c6b83d8613144004c0413528863dc6b5c743da"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/gcc-boot-13.1.0"
    sha256 ventura: "c5dd37708ce3b9aff79285f99299efaca2dac040c59687ca75df28ac2946f687"
  end

  keg_only "bootstrap formula"

  depends_on "doxygen"   => :build
  depends_on "gcc-strap" => :build
  depends_on "gettext"   => :build
  depends_on "make"      => :build
  depends_on "python"    => :build
  depends_on "texinfo"   => :build

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

  def install
    ENV.prepend_path "PATH", Formula["gcc-strap"].bin
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
      system "gmake"
      system "gmake", "install", "-j", "1"
      system "gmake", "-C", "gcc", "install-man", "install-info", "-j", "1"

      # make libstdc++ documentation
      system "gmake", "-C", "#{triple}/libstdc++-v3/doc", "prefix=#{prefix}", "doc-man-doxygen"
      system "gmake", "-C", "#{triple}/libstdc++-v3/doc", "prefix=#{prefix}", "doc-install-man"
      system "gmake", "-C", "#{triple}/libstdc++-v3/po", "prefix=#{prefix}", "install"
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
