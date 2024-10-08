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
    rebuild 1
    sha256 ventura: "3630d3846139f42462d07c0d303451a66008ae3ee5d0fd9d8e083277d27040a3"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on "bdw-gc" => :build
  depends_on "gcc-strap" => :build
  depends_on "make" => :build
  depends_on "python"  => :build

  depends_on "gettext"
  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "zstd"

  uses_from_macos "libiconv"
  uses_from_macos "zlib"

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
      --enable-objc-gc
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
        headers gengtype lto-wrapper
        man info po
      ].each do |t|
        system "make", "-C", "gcc", "DESTDIR=#{instdir}", "install-#{t}"
      end
      system "make", "-C", "gcc", "DESTDIR=#{instdir}", "c.install-plugin"
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
      %w[fortran dc ++ m2].each { |m| rm_r man1/"g#{m}.1" }
      %w[fortran nat-style nat_rm nat_ugn dc].each do |i|
        rm_r info/"g#{i}.info"
      end
      rm_r lib/"gcc"/triple/version_suffix/"finclude"
    end

    %w[gcc gcc-ar gcc-nm gcc-ranlib].each do |x|
      rm bin/x
      bin.install_symlink bin/"#{triple}-#{x}" => x
    end
    rm_r Dir[lib/"gcc"/triple/version_suffix/"plugin/libcp1plugin.*"]
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
