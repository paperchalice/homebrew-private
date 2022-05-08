class Gnat < Formula
  desc "GNU NYU Ada Translator"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-12.1.0/gcc-12.1.0.tar.xz"
  sha256 "62fd634889f31c02b64af2c468f064b47ad1ca78411c45abe6ac4b5f8dd19c7b"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  head "https://gcc.gnu.org/git/gcc.git", branch: "master"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/gnat-12.1.0"
    sha256 monterey: "0014cf9a2fd5e8ea2d5247439b2d23a1bce1bce06e20232f9a49ae694a893d72"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on "gcc-strap" => :build
  depends_on "python"    => :build

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
    ENV.prepend_path "PATH", Formula["gcc-strap"].bin
    ENV.delete "CC"
    ENV.delete "CXX"
    ENV.delete "LD"

    # don't resolve symlinks
    inreplace "libiberty/make-relative-prefix.c", /(?<=, )1/, "0"

    languages = %w[c c++ ada]

    pkgversion = "Homebrew GCC #{pkg_version}"
    triple = "#{Hardware::CPU.arch}-apple-#{OS.kernel_name.downcase}#{OS.kernel_version.major}"

    args = %W[
      --build=#{triple}
      --prefix=#{prefix}
      --disable-multilib
      --enable-nls
      --enable-host-shared
      --enable-checking=release
      --enable-languages=#{languages.join ","}
      --libexecdir=#{lib}
      --with-gcc-major-version-only
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
      %w[common man info].each { |t| system "make", "-C", "gcc", "ada.install-#{t}" }
      (lib/"gcc"/triple/version_suffix).install "gcc/gnat1"
      system "make", "-C", "#{triple}/libada",
        "INSTALL=install", "INSTALL_DATA=install",
        "DESTDIR=#{prefix}", "install"
      MachO::Tools.add_rpath "#{lib}/gcc/#{triple}/#{version.major}/adalib/#{shared_library "libgnarl"}",
                             "@loader_path"
    end
  end

  test do
    (testpath/"hello_ada.adb").write <<~EOS
      with Text_IO; use Text_IO;
      procedure hello is
      begin
        Put_Line("Hello, world!");
      end hello;
    EOS
    system "gnat", "make", "hello_ada.adb"
    assert_equal "Hello, world!\n", `./hello_ada`
  end
end
