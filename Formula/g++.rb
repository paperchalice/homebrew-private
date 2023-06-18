class Gxx < Formula
  desc "GNU C++ compiler"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-13.1.0/gcc-13.1.0.tar.xz"
  sha256 "61d684f0aa5e76ac6585ad8898a2427aade8979ed5e7f85492286c4dfc13ee86"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  head "https://gcc.gnu.org/git/gcc.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?gcc[._-]v?(\d+(?:\.\d+)+)(?:/?["' >]|\.t)}i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/g++-13.1.0"
    sha256 cellar: :any, ventura: "05f6adc3fa433a7d7c131661819a94e263189c8e7ab58b1ce1098f0556f1d7a1"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on "doxygen" => :build
  depends_on "gettext" => :build
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
    sha256 "62747de482fece5cc4655d742904adc79425ee323b1bf7607cf2e6b81368251d"
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
      --enable-languages=#{languages.join(",")}
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
      --with-sysroot=#{default_sysroot}
    ]

    instdir = Pathname.pwd/"instdir"
    mkdir "build" do
      system "../configure", *args
      system "make"

      # make documentation
      system "make", "-C", "#{triple}/libstdc++-v3/doc", "DESTDIR=#{instdir}", "doc-man-doxygen"
      system "make", "-C", "#{triple}/libstdc++-v3/doc", "DESTDIR=#{instdir}", "doc-install-man"
      system "make", "-C", "#{triple}/libstdc++-v3/po", "DESTDIR=#{instdir}", "install"
      # sanitizer is now unsupported on darwin
      system "make", "-C", "#{triple}/libstdc++-v3", "DESTDIR=#{instdir}", "install"
      %w[common man info plugin].each do |t|
        system "make", "-C", "gcc", "DESTDIR=#{instdir}", "c++.install-#{t}"
      end
      mv Dir["#{instdir}#{HOMEBREW_PREFIX}/*"], prefix

      (lib/"gcc"/triple/version_suffix).install "gcc/cc1plus"
      %W[c++ g++ #{triple}-c++].each do |x|
        rm bin/x
        bin.install_symlink bin/"#{triple}-g++" => x
      end
      rm_rf lib/"gcc"/triple/version_suffix/"cc1"
    end
    rm_rf man3/"stdheader.dSYM"
    [man1, man3].each { |d| Utils::Gzip.compress(*Dir[d/"*"]) }
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
