class Gnat < Formula
  desc "GNU NYU Ada Translator"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-12.2.0/gcc-12.2.0.tar.xz"
  sha256 "e549cf9cf3594a00e27b6589d4322d70e0720cdd213f39beb4181e06926230ff"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  head "https://gcc.gnu.org/git/gcc.git", branch: "master"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/gnat-12.2.0"
    sha256 cellar: :any, monterey: "38b579adec34c539437e7f8fc7a41b808f8dd3053028ee68cc21529057d74e9c"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on "gcc-strap" => :build
  depends_on "python"    => :build

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
    ENV.prepend_path "PATH", Formula["gcc-strap"].bin
    ENV.delete "CC"
    ENV.delete "CXX"
    ENV.delete "LD"
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include"

    languages = %w[c c++ ada]

    pkgversion = "Homebrew GCC #{pkg_version}"
    triple = "#{Hardware::CPU.arch}-apple-#{OS.kernel_name.downcase}#{OS.kernel_version.major}"

    args = %W[
      --build=#{triple}
      --prefix=#{HOMEBREW_PREFIX}
      --disable-multilib
      --disable-bootstrap
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
      --with-system-zlib
      --with-zstd=#{Formula["zstd"].opt_prefix}
      --with-pkgversion=#{pkgversion}
      --with-bugurl=#{tap.issues_url}
      --with-sysroot=#{MacOS.sdk_path}
    ]

    mkdir "build" do
      system "../configure", *args
      system "make"
      %w[common man info].each { |t| system "make", "-C", "gcc", "prefix=#{prefix}", "ada.install-#{t}" }
      (lib/"gcc"/triple/version_suffix).install "gcc/gnat1"
      system "make", "-C", "#{triple}/libada",
        "INSTALL=install", "INSTALL_DATA=install",
        "DESTDIR=#{prefix}", "install"
      MachO::Tools.add_rpath "#{lib}/gcc/#{triple}/#{version.major}/adalib/#{shared_library "libgnarl"}",
                             "@loader_path"
    end

    rm info/"dir"
    system "gzip", *Dir[info/"*"]
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
