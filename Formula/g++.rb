class Gxx < Formula
  desc "GNU C++ compiler"
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
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/g++-11.2.0"
    rebuild 1
    sha256 big_sur: "eaea4892e504a80932ea5f2d36fa58ced3330920acc1da0696dbd9205fd8ca63"
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

    pkgversion = "Homebrew GCC #{pkg_version} #{build.used_options*" "}".strip
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"

    args = %W[
      --prefix=#{prefix}
      --disable-multilib
      --enable-nls
      --enable-host-shared
      --enable-checking=release
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

    # fix linkage
    gcc = Formula["paperchalice/private/gcc"]
    %w[asan ubsan stdc++].each do |l|
      MachO::Tools.change_install_name lib/shared_library("lib#{l}"),
        "#{lib}/#{shared_library "libgcc_s", 1}",
        "#{gcc.lib}/#{shared_library "libgcc_s", 1}"
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
