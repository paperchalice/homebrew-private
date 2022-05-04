class Gcc < Formula
  desc "GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-11.3.0/gcc-11.3.0.tar.xz"
  sha256 "b47cf2818691f5b1e21df2bb38c795fac2cfbd640ede2d0a5e1c89e338a3ac39"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  head "https://gcc.gnu.org/git/gcc.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?gcc[._-]v?(\d+(?:\.\d+)+)(?:/?["' >]|\.t)}i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/gcc-11.3.0"
    sha256 monterey: "6389dde3eb6e1192ffa6b9173faa5b04cbb0b52dad9bb48aa1db0c94ce628220"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on "gcc-strap" => :build
  depends_on "python"    => :build

  depends_on "gettext"
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

  def version_suffix
    if build.head?
      "HEAD"
    else
      version.major.to_s
    end
  end

  def install
    ENV.prepend_path "PATH", Formula["gcc-strap"].bin
    ENV.delete "CC"
    ENV.delete "CXX"
    ENV.delete "LD"

    # don't resolve symlinks
    inreplace "libiberty/make-relative-prefix.c", /(?<=, )1/, "0"

    languages = %w[ada c c++ d objc obj-c++ fortran]

    pkgversion = "Homebrew GCC #{pkg_version} #{build.used_options*" "}".strip
    triple = "#{Hardware::CPU.arch}-apple-#{OS.kernel_name.downcase}#{OS.kernel_version.major}"

    args = %W[
      --build=#{triple}
      --prefix=#{prefix}
      --disable-multilib
      --enable-checking=release
      --enable-libphobos
      --enable-host-shared
      --enable-install-libiberty
      --enable-languages=#{languages.join(",")}
      --enable-nls
      --enable-shared
      --libexecdir=#{lib}
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
      --with-sysroot=#{MacOS.sdk_path}
    ]

    mkdir "build" do
      system "../configure", *args
      system "make"

      %w[
        cpp driver gcc-ar mkheaders
        headers plugin lto-wrapper
        man info po
      ].each do |t|
        system "make", "-C", "gcc", "install-#{t}"
      end
      system "make", "install-fixincludes"
      system "make", "install-libcc1"
      %w[gcov gcov-dump gcov-tool].each { |x| bin.install "gcc/#{x}" }
      %w[cc1 collect2 lto1].each do |t|
        (lib/"gcc"/triple/version_suffix).install "gcc/#{t}"
      end
      %w[fortran dc ++].each { |m| rm_rf man1/"g#{m}.1" }
      %w[fortran nat-style nat_rm nat_ugn dc].each do |i|
        rm_rf info/"g#{i}.info"
      end

      %w[atomic gcc gomp itm quadmath ssp].each do |l|
        system "make", "-C", "#{triple}/lib#{l}", "install"
      end
      system "make", "-C", "libiberty", "install"
      rm_rf lib/"gcc"/triple/version_suffix/"finclude"
    end

    %w[gcc gcc-ar gcc-nm gcc-ranlib].each do |x|
      rm bin/x
      bin.install_symlink bin/"#{triple}-#{x}" => x
    end
    rm bin/"#{triple}-gcc"
    bin.install_symlink bin/"#{triple}-gcc-#{version.major}" => "#{triple}-gcc"
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
