class GccObjc < Formula
  desc "GNU Objective C/C++ frontend"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-12.2.0/gcc-12.2.0.tar.xz"
  sha256 "e549cf9cf3594a00e27b6589d4322d70e0720cdd213f39beb4181e06926230ff"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  head "https://gcc.gnu.org/git/gcc.git", branch: "master"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/gcc-objc-12.2.0"
    sha256 cellar: :any, monterey: "2fc5ccd3b747c1b77c31d9d9510d0c1ce7a0032ece278cafdc8c07816bc93c2a"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on "python" => :build

  depends_on "gcc-base"
  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "zstd"

  uses_from_macos "libiconv"
  uses_from_macos "zlib"

  on_linux do
    depends_on "binutils"
  end

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

  patch do
    url "https://github.com/paperchalice/homebrew-private/raw/main/Patch/gcc.diff"
    sha256 "691af73554281887a941ea145ed2ddb89be1e352020949c0c3d2ca3a30fc75a1"
  end

  def version_suffix
    if build.head?
      "HEAD"
    else
      version.major.to_s
    end
  end

  def install
    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    languages = %w[c c++ objc obj-c++]

    pkgversion = "Homebrew GCC #{pkg_version} #{build.used_options*" "}".strip
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    triple = "#{cpu}-apple-darwin#{OS.kernel_version.major}"

    args = %W[
      --build=#{triple}
      --prefix=#{HOMEBREW_PREFIX}
      --disable-multilib
      --disable-bootstrap
      --enable-nls
      --enable-host-shared
      --enable-checking=release
      --enable-libphobos
      --enable-languages=#{languages.join ","}
      --libexecdir=#{HOMEBREW_PREFIX}/lib
      --with-gcc-major-version-only
      --with-gmp=#{Formula["gmp"].opt_prefix}
      --with-mpfr=#{Formula["mpfr"].opt_prefix}
      --with-mpc=#{Formula["libmpc"].opt_prefix}
      --with-isl=#{Formula["isl"].opt_prefix}
      --with-python-dir=#{Language::Python.site_packages "python3"}
      --with-zstd=#{Formula["zstd"].opt_prefix}
      --with-system-zlib
      --with-pkgversion=#{pkgversion}
      --with-bugurl=#{tap.issues_url}
      --with-sysroot=#{MacOS.sdk_path}
    ]

    mkdir "build" do
      system "../configure", *args
      system "make"
      system "make", "-C", "#{triple}/libobjc", "prefix=#{prefix}", "install"
      %w[cc1obj cc1objplus].each { |t| (lib/"gcc/#{triple}/#{version_suffix}").install "gcc/#{t}" }
    end
  end

  test do
    # This formula is not work:
    # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=90709
    (testpath/"test.m").write <<~EOS
      #import <Foundation/Foundation.h>

      int main(int argc, const char * argv[]) {
          @autoreleasepool {
              NSLog(@"Hello, World!");
          }
          return 0;
      }
    EOS
    system "echo"
  end
end
