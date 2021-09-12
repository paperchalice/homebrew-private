class GccDoc < Formula
  desc "GNU compiler collection documents"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-11.2.0/gcc-11.2.0.tar.xz"
  sha256 "d08edc536b54c372a1010ff6619dd274c0f1603aa49212ba20f7aa2cda36fa8b"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  head "https://gcc.gnu.org/git/gcc.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?gcc[._-]v?(\d+(?:\.\d+)+)(?:/?["' >]|\.t)}i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/gcc-doc-11.2.0"
    sha256 cellar: :any_skip_relocation, big_sur: "cf630b467fa3e65f76d96cf2d47fc2f87e39b66eabf3fd5df6609117713a99bf"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on "gmp"     => :build
  depends_on "isl"     => :build
  depends_on "libmpc"  => :build
  depends_on "mpfr"    => :build
  depends_on "python"  => :build
  depends_on "texinfo" => :build
  depends_on "zstd"    => :build

  def version_suffix
    if build.head?
      "HEAD"
    else
      version.major.to_s
    end
  end

  resource "bootstrap_gcc" do
    url "https://phoenixnap.dl.sourceforge.net/project/gnuada/GNAT_GCC%20Mac%20OS%20X/11.1.0/native/gcc-11.1.0-x86_64-apple-darwin15.pkg"
    sha256 "d947b5db0576cb62942e5ce61f3ef53fb679f07b1adff7a4c0fa19a5e72a9532"
  end

  def install
    ENV.append_path "PATH", "/Library/TeX/texbin"
    system "tex", "--version"
    if Hardware::CPU.intel?
      resource("bootstrap_gcc").stage do
        system "pkgutil", "--expand-full", "gcc-11.1.0-x86_64-apple-darwin15.pkg", buildpath/"bootstrap_gcc"
      end
      bootstrap_gcc_prefix = buildpath/"bootstrap_gcc/gcc-11.1.0-x86_64-apple-darwin15.pkg/Payload"
      inreplace "configure", /\${CC}(?= -c conftest\.adb)/, bootstrap_gcc_prefix/"bin/gcc"
      open("gcc/ada/gcc-interface/Make-lang.in", "a") { |f| f.puts "override CC = #{bootstrap_gcc_prefix}/bin/gcc" }

      ENV.append_path "PATH", bootstrap_gcc_prefix/"bin"
      ENV["ADAC"] = bootstrap_gcc_prefix/"bin/gcc"
    end

    # don't resolve symlinks
    inreplace "libiberty/make-relative-prefix.c", "(progname, bin_prefix, prefix, 1)",
      "(progname, bin_prefix, prefix, 0)"

    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    languages = %w[ada c c++ d objc obj-c++ fortran]

    pkgversion = "Homebrew GCC #{pkg_version} #{build.used_options*" "}".strip
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"

    args = %W[
      --prefix=#{prefix}
      --disable-multilib
      --enable-nls
      --enable-host-shared
      --enable-checking=release
      --enable-shared
      --enable-languages=#{languages.join(",")}
      --libexecdir=#{lib}
      --with-gcc-major-version-only
      --with-gmp=#{Formula["gmp"].opt_prefix}
      --with-mpfr=#{Formula["mpfr"].opt_prefix}
      --with-mpc=#{Formula["libmpc"].opt_prefix}
      --with-isl=#{Formula["isl"].opt_prefix}
      --with-python-dir=#{Language::Python.site_packages "python3"}
      --with-zstd=#{Formula["zstd"].opt_prefix}
      --with-pkgversion=#{pkgversion}
      --with-bugurl=#{tap.issues_url}
    ]
    # libphobos is part of gdc
    args << "--enable-libphobos" if Hardware::CPU.intel?

    triple = "#{cpu}-apple-darwin#{OS.kernel_version.major}"
    if OS.mac?
      args << "--build=#{triple}"
      args << "--with-system-zlib"

      # Workaround for Xcode 12.5 bug on Intel
      # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=100340
      args << "--without-build-config" if Hardware::CPU.intel? && DevelopmentTools.clang_build_version >= 1205

      # System headers may not be in /usr/include
      ENV["SDKROOT"] = MacOS.sdk_path
      args << "--with-sysroot=#{MacOS.sdk_path}"
    end

    mkdir "build" do
      system "../configure", *args
      system "make", "BOOT_LDFLAGS=-Wl,-headerpad_max_install_names"
      system "make", "pdf"
      system "make", "install-pdf"
    end
  end

  test do
    system "echo"
  end
end
