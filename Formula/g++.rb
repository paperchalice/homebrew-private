class Gxx < Formula
  desc "GNU C++ compiler"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-12.1.0/gcc-12.1.0.tar.xz"
  sha256 "62fd634889f31c02b64af2c468f064b47ad1ca78411c45abe6ac4b5f8dd19c7b"
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

  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "paperchalice/private/gcc"
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
    # don't resolve symlinks
    inreplace "libiberty/make-relative-prefix.c", /(?<=, )1/, "0"

    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    languages = %w[c c++]

    pkgversion = "Homebrew GCC #{pkg_version}"
    triple = "#{Hardware::CPU.arch}-apple-darwin#{OS.kernel_version.major}"

    args = %W[
      --prefix=#{prefix}
      --disable-multilib
      --build=#{triple}
      --enable-nls
      --enable-host-shared
      --enable-checking=release
      --enable-languages=#{languages.join(",")}
      --libexecdir=#{lib}
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
      system "../configure", *args
      system "make"

      # make documentation
      system "make", "-C", "#{triple}/libstdc++-v3/doc", "doc-man-doxygen"
      system "make", "-C", "#{triple}/libstdc++-v3/doc", "doc-install-man"
      system "make", "-C", "#{triple}/libstdc++-v3/po", "install"

      (lib/"gcc"/triple/version_suffix).install "gcc/cc1plus"
      %w[sanitizer stdc++-v3].each do |l|
        system "make", "-C", "#{triple}/lib#{l}", "install"
      end
      %w[common man info].each { |t| system "make", "-C", "gcc", "c++.install-#{t}" }
      bin.install bin/"g++" => "#{triple}-g++"
      bin.install_symlink bin/"#{triple}-g++" => "#{triple}-c++"
      %w[g++ c++].each do |x|
        bin.install_symlink bin/"#{triple}-g++" => x
      end
      rm_rf lib/"gcc"/triple/version_suffix/"cc1"
    end
  end

  test do
    (testpath/"hello.cpp").write <<~EOS
      #include <iostream>
      int main() {
        std::cout << "hello" << std::endl;
        return 0;
      }
    EOS
    system HOMEBREW_PREFIX/"bin/g++", "hello.cpp"
    system "./a.out"
  end
end
