class Gxx < Formula
  desc "GNU C++ compiler"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-12.2.0/gcc-12.2.0.tar.xz"
  sha256 "e549cf9cf3594a00e27b6589d4322d70e0720cdd213f39beb4181e06926230ff"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  head "https://gcc.gnu.org/git/gcc.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?gcc[._-]v?(\d+(?:\.\d+)+)(?:/?["' >]|\.t)}i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/g++-12.1.0"
    sha256 monterey: "8fca846391d52f78dffb7c577ad3c022daf9115310a4ef6684346a05d8b4527b"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on "doxygen" => :build
  depends_on "gettext" => :build
  depends_on "python"  => :build

  depends_on "gcc-base"
  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "zstd"

  uses_from_macos "gzip" => :build
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
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include"

    languages = %w[c c++]

    pkgversion = "Homebrew GCC #{pkg_version}"
    triple = "#{Hardware::CPU.arch}-apple-darwin#{OS.kernel_version.major}"

    args = %W[
      --prefix=#{HOMEBREW_PREFIX}
      --disable-multilib
      --disable-bootstrap
      --build=#{triple}
      --enable-nls
      --enable-host-shared
      --enable-checking=release
      --enable-languages=#{languages.join(",")}
      --libexecdir=#{HOMEBREW_PREFIX}/lib
      --with-sysroot=#{MacOS.sdk_path}
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
    ]

    mkdir "build" do
      destdir = buildpath/"instdir"
      system "../configure", *args
      system "make"

      # make documentation
      system "make", "-C", "#{triple}/libstdc++-v3/doc", "DESTDIR=#{destdir}", "doc-man-doxygen"
      system "make", "-C", "#{triple}/libstdc++-v3/doc", "DESTDIR=#{destdir}", "doc-install-man"
      system "make", "-C", "#{triple}/libstdc++-v3/po", "DESTDIR=#{destdir}", "install"

      %w[sanitizer stdc++-v3].each do |l|
        system "make", "-C", "#{triple}/lib#{l}", "DESTDIR=#{destdir}", "install"
      end
      %w[common man info].each { |t| system "make", "-C", "gcc", "DESTDIR=#{destdir}", "c++.install-#{t}" }

      prefix.install Dir["#{destdir}/#{HOMEBREW_PREFIX}/*"]
      (lib/"gcc"/triple/version_suffix).install "gcc/cc1plus"
      %W[c++ g++ #{triple}-c++].each do |x|
        rm bin/x
        bin.install_symlink bin/"#{triple}-g++" => x
      end
      rm_rf lib/"gcc"/triple/version_suffix/"cc1"
    end
    rm_rf man3/"stdheader.dSYM"
    [man1, man3].each { |d| system "gzip", *Dir[d/"*"] }
  end

  test do
    (testpath/"hello.cpp").write <<~EOS
      #include <iostream>
      int main() {
        std::cout << "hello" << std::endl;
        return 0;
      }
    EOS
    system bin/"g++", "hello.cpp"
    system "./a.out"
  end
end
