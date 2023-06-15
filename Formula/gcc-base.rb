class GccBase < Formula
  desc "GNU compiler collection"
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
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/gcc-base-13.1.0"
    sha256 ventura: "6d6c5aba1d84c32ff8efd6e944c7b90f9e22dcd0d7e1c0d93aa30f1281f913db"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on "gcc-strap" => :build
  depends_on "make"      => :build
  depends_on "python"    => :build

  depends_on "gettext"
  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "zstd"

  uses_from_macos "gzip" => :build
  uses_from_macos "libiconv"
  uses_from_macos "zlib"

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

    languages = %w[ada c c++ d objc obj-c++ fortran jit lto m2]

    pkgversion = "Homebrew GCC #{pkg_version}"
    triple = "#{Hardware::CPU.arch}-apple-#{OS.kernel_name.downcase}"
    default_sysroot = MacOS.sdk_path.sub(/\d+/, "")

    args = %W[
      --build=#{triple}
      --prefix=#{HOMEBREW_PREFIX}
      --disable-multilib
      --disable-bootstrap
      --enable-checking=release
      --enable-libphobos
      --enable-host-shared
      --enable-install-libiberty
      --enable-languages=#{languages.join(",")}
      --enable-nls
      --enable-shared
      --libexecdir=#{HOMEBREW_PREFIX}/lib
      --with-gcc-major-version-only
      --with-gettext=#{Formula["gettext"].opt_prefix}
      --with-gmp=#{Formula["gmp"].opt_prefix}
      --with-mpfr=#{Formula["mpfr"].opt_prefix}
      --with-mpc=#{Formula["libmpc"].opt_prefix}
      --with-isl=#{Formula["isl"].opt_prefix}
      --with-python-dir=#{Language::Python.site_packages "python3"}
      --with-system-zlib
      --with-zstd=#{Formula["zstd"].opt_prefix}
      --with-pkgversion=#{pkgversion}
      --with-bugurl=#{tap.issues_url}
      --with-sysroot=#{default_sysroot}
      --with-arch=native
      --with-tune=native
    ]

    instdir = Pathname.pwd/"instdir"
    mkdir "build" do
      system "../configure", *args
      system "make"

      %w[
        cpp driver gcc-ar mkheaders
        headers plugin lto-wrapper
        man info po
      ].each do |t|
        system "make", "-C", "gcc", "DESTDIR=#{instdir}", "install-#{t}"
      end
      system "make", "DESTDIR=#{instdir}", "install-fixincludes"
      system "make", "DESTDIR=#{instdir}", "install-libcc1"
      %w[atomic gcc gomp itm quadmath ssp].each do |l|
        system "make", "DESTDIR=#{instdir}", "-C", "#{triple}/lib#{l}", "install"
      end
      mv Dir["#{instdir}#{HOMEBREW_PREFIX}/*"], prefix
      %w[gcov gcov-dump gcov-tool].each { |x| bin.install "gcc/#{x}" }
      %w[cc1 collect2 lto1].each do |t|
        (lib/"gcc"/triple/version_suffix).install "gcc/#{t}"
      end
      %w[fortran dc ++].each { |m| rm_rf man1/"g#{m}.1" }
      %w[fortran nat-style nat_rm nat_ugn dc].each do |i|
        rm_rf info/"g#{i}.info"
      end
      rm_rf lib/"gcc"/triple/version_suffix/"finclude"
    end

    %w[gcc gcc-ar gcc-nm gcc-ranlib].each do |x|
      rm bin/x
      bin.install_symlink bin/"#{triple}-#{x}" => x
    end
    rm bin/"#{triple}-gcc"
    bin.install_symlink bin/"#{triple}-gcc-#{version.major}" => "#{triple}-gcc"
    [man1, man7, info].each { |d| Utils::Gzip.compress(*Dir[d/"*"]) }
  end

  test do
    (testpath/"hello-c.c").write <<~EOS
      #include <stdio.h>
      int main(void)
      {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system bin/"gcc", "hello-c.c"
    system "./a.out"
  end
end
