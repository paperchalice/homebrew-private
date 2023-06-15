class Gm2 < Formula
  desc "GNU modula-2 compiler"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-13.1.0/gcc-13.1.0.tar.xz"
  sha256 "61d684f0aa5e76ac6585ad8898a2427aade8979ed5e7f85492286c4dfc13ee86"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  head "https://gcc.gnu.org/git/gcc.git", branch: "master"

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on "gcc-strap" => :build
  depends_on "make" => :build
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
    sha256 "187c0cff0975d675adeff130ee25d73c09006fce6edd9836d511fdf82cf90230"
  end

  def version_suffix
    if build.head?
      "HEAD"
    else
      version.major.to_s
    end
  end

  def install
    ENV.prepend_path "PATH", Formula["gcc-strap"].bin
    ENV.prepend_path "PATH", Formula["make"].libexec/"gnubin"
    ENV.delete "CC"
    ENV.delete "CXX"
    ENV.delete "LD"
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include"

    languages = %w[c c++ m2]

    pkgversion = "Homebrew GCC #{pkg_version}"
    triple = "#{Hardware::CPU.arch}-apple-#{OS.kernel_name.downcase}"
    default_sysroot = MacOS.sdk_path.sub(/\d+/, "")

    args = %W[
      --prefix=#{HOMEBREW_PREFIX}
      --disable-multilib
      --disable-bootstrap
      --build=#{triple}
      --enable-nls
      --enable-host-shared
      --enable-checking=release
      --enable-languages=#{languages.join ","}
      --libexecdir=#{HOMEBREW_PREFIX}/lib
      --with-gcc-major-version-only
      --with-gmp=#{Formula["gmp"].opt_prefix}
      --with-mpfr=#{Formula["mpfr"].opt_prefix}
      --with-mpc=#{Formula["libmpc"].opt_prefix}
      --with-isl=#{Formula["isl"].opt_prefix}
      --with-python-dir=#{Language::Python.site_packages "python3"}
      -with-system-zlib
      --with-zstd=#{Formula["zstd"].opt_prefix}
      --with-pkgversion=#{pkgversion}
      --with-bugurl=#{tap.issues_url}
      --with-sysroot=#{default_sysroot}
    ]

    instdir = Pathname.pwd/"instdir"
    mkdir "build" do
      system "../configure", *args
      system "make"
      system "make", "-C", "gcc", "DESTDIR=#{instdir}", "m2.install"
      system "make", "-C", "#{triple}/libgm2", "DESTDIR=#{instdir}", "install"
      mv Dir["#{instdir}#{HOMEBREW_PREFIX}/*"], prefix
      rm man1/"gm2.1"
    end

    [man1, info].each { |d| Utils::Gzip.compress(*Dir[d/"*"]) }
  end

  test do
    system "echo"
  end
end
