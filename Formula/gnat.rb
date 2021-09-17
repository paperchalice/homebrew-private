class Gnat < Formula
  desc "GNU NYU Ada Translator"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-11.2.0/gcc-11.2.0.tar.xz"
  sha256 "d08edc536b54c372a1010ff6619dd274c0f1603aa49212ba20f7aa2cda36fa8b"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  head "https://gcc.gnu.org/git/gcc.git", branch: "master"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/gnat-11.2.0"
    sha256 big_sur: "cc3b63c1bdd5615b48bcde5e2e37ac27457676877001b0d5623336a9721331da"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on "python" => :build

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

  resource "bootstrap_gcc" do
    url "https://phoenixnap.dl.sourceforge.net/project/gnuada/GNAT_GCC%20Mac%20OS%20X/11.1.0/native/gcc-11.1.0-x86_64-apple-darwin15.pkg"
    sha256 "d947b5db0576cb62942e5ce61f3ef53fb679f07b1adff7a4c0fa19a5e72a9532"
  end

  def install
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
    inreplace "libiberty/make-relative-prefix.c", /(?<=, )1/, "0"

    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    languages = %w[c c++ ada]

    pkgversion = "Homebrew GCC #{pkg_version} #{build.used_options*" "}".strip
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"

    args = %W[
      --prefix=#{prefix}
      --disable-multilib
      --enable-nls
      --enable-host-shared
      --enable-checking=release
      --enable-libphobos
      --enable-languages=#{languages.join ","}
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

      # Use -headerpad_max_install_names in the build,
      # otherwise updated load commands won't fit in the Mach-O header.
      # This is needed because `gcc` avoids the superenv shim.
      system "make", "BOOT_LDFLAGS=-Wl,-headerpad_max_install_names"
      %w[common man info].each { |t| system "make", "-C", "gcc", "ada.install-#{t}" }
      (lib/"gcc"/triple/version_suffix).install "gcc/gnat1"
      system "make", "-C", "#{triple}/libada",
        "INSTALL=install", "INSTALL_DATA=install",
        "DESTDIR=#{prefix}", "install"

      gcc = Formula["paperchalice/private/gcc"]
      adalib = lib/"gcc"/triple/version_suffix/"adalib"
      %w[rl t].each do |l|
        MachO::Tools.change_install_name adalib/shared_library("libgna#{l}"),
          "#{lib}/#{shared_library "libgcc_s", 1}",
          "#{gcc.lib}/#{shared_library "libgcc_s", 1}"
      end
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
