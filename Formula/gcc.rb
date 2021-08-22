class Gcc < Formula
  desc "GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-11.2.0/gcc-11.2.0.tar.xz"
  sha256 "d08edc536b54c372a1010ff6619dd274c0f1603aa49212ba20f7aa2cda36fa8b"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  head "https://gcc.gnu.org/git/gcc.git"

  livecheck do
    # Should be
    # url :stable
    # but that does not work with the ARM-specific branch above
    url :stable
    regex(%r{href=.*?gcc[._-]v?(\d+(?:\.\d+)+)(?:/?["' >]|\.t)}i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/gcc-11.2.0"
    rebuild 1
    sha256 big_sur: "cd939c17a035c75eeec38b14338326228bd02d6426e4793669dab6f71e4814ad"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on "python" => :build

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

  resource "bootstrap_gcc" do
    url "https://community.download.adacore.com/v1/aefa0616b9476874823a7974d3dd969ac13dfe3a?filename=gnat-2020-20200818-x86_64-darwin-bin.dmg"
    sha256 "915cd7260ef1bc363d4ff6249343183c4f989ec0a7d779f125a5be6c194f790f"
  end

  resource "install_script" do
    url "https://raw.githubusercontent.com/AdaCore/gnat_community_install_script/master/install_script.qs"
    sha256 "93df6ca93265e97add6751e34a88e11dbcf8eb64657b49c12b4bb3d53f1a5acd"
  end

  def install
    if Hardware::CPU.intel?
      resources.each { |r| r.stage buildpath/"bootstrap_gcc" }
      system "ls", buildpath/"bootstrap_gcc"
      system "ls", buildpath/"bootstrap_gcc/Contents"
      cd "bootstrap_gcc" do
        gnat_install_args = %W[
          --script ./install_script.qs
          InstallPrefix=#{buildpath}/bgcc
          Components=com.adacore.gnat
        ]
        system "./Contents/MacOS/gnat-2020-20200818-x86_64-darwin-bin", *gnat_install_args
      end
      system "ls", buildpath/"bgcc"

      bootstrap_gcc_prefix = buildpath/"bootstrap_gcc/gcc-11.1.0-x86_64-apple-darwin15.pkg/Payload"
      inreplace "configure", /\${CC}(?= -c conftest\.adb)/, bootstrap_gcc_prefix/"bin/gcc"
      open("gcc/ada/gcc-interface/Make-lang.in", "a") { |f| f.puts "override CC = #{bootstrap_gcc_prefix}/bin/gcc" }

      ENV.append_path "PATH", bootstrap_gcc_prefix/"bin"
      ENV["ADAC"] = bootstrap_gcc_prefix/"bin/gcc"
    end

    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    # We avoiding building:
    #  - Go, currently not supported on macOS
    #  - BRIG
    languages = %w[c c++ jit objc obj-c++ fortran]
    languages << "ada" << "d" if Hardware::CPU.intel?

    pkgversion = "Homebrew GCC #{pkg_version} #{build.used_options*" "}".strip
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"

    args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}/gcc/#{version_suffix}
      --enable-nls
      --enable-host-shared
      --enable-checking=release
      --enable-languages=#{languages.join(",")}
      --with-gmp=#{Formula["gmp"].opt_prefix}
      --with-mpfr=#{Formula["mpfr"].opt_prefix}
      --with-mpc=#{Formula["libmpc"].opt_prefix}
      --with-isl=#{Formula["isl"].opt_prefix}
      --with-zstd=#{Formula["zstd"].opt_prefix}
      --with-pkgversion=#{pkgversion}
      --with-bugurl=#{tap.issues_url}
    ]
    # libphobos is part of gdc
    args << "--enable-libphobos" if Hardware::CPU.intel?

    on_macos do
      args << "--build=#{cpu}-apple-darwin#{OS.kernel_version.major}"
      args << "--with-system-zlib"

      # Xcode 10 dropped 32-bit support
      args << "--disable-multilib" if DevelopmentTools.clang_build_version >= 1000

      # Workaround for Xcode 12.5 bug on Intel
      # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=100340
      args << "--without-build-config" if Hardware::CPU.intel? && DevelopmentTools.clang_build_version >= 1205

      # System headers may not be in /usr/include
      sdk = MacOS.sdk_path_if_needed
      if sdk
        args << "--with-native-system-header-dir=/usr/include"
        args << "--with-sysroot=#{sdk}"
        ENV["SDKROOT"] = MacOS.sdk_path
      end

      # Ensure correct install names when linking against libgcc_s;
      # see discussion in https://github.com/Homebrew/legacy-homebrew/pull/34303
      inreplace "libgcc/config/t-slibgcc-darwin", "@shlib_slibdir@", "#{HOMEBREW_PREFIX}/lib"
    end

    mkdir "build" do
      system "../configure", *args

      # Use -headerpad_max_install_names in the build,
      # otherwise updated load commands won't fit in the Mach-O header.
      # This is needed because `gcc` avoids the superenv shim.
      system "make", "BOOT_LDFLAGS=-Wl,-headerpad_max_install_names"
      system "make", "install"
    end

    triple = (libexec/"gcc").children[0].stem

    %w[gcc gcc-ar gcc-nm gcc-ranlib gfortran gdc c++ g++].each do |x|
      rm bin/x
      bin.install_symlink bin/"#{triple}-#{x}" => x
    end
    rm bin/"#{triple}-gcc"
    rm bin/"#{triple}-c++"
    bin.install_symlink bin/"#{triple}-gcc-#{version}" => "#{triple}-gcc"
    bin.install_symlink bin/"#{triple}-g++" => "#{triple}-c++"

    lib.install_symlink Pathname.glob(lib/"gcc/#{version_suffix}/lib*")
  end

  test do
    (testpath/"hello-c.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}/gcc", "-o", "hello-c", "hello-c.c"
    assert_equal "Hello, world!\n", `./hello-c`

    (testpath/"hello-cc.cc").write <<~EOS
      #include <iostream>
      struct exception { };
      int main()
      {
        std::cout << "Hello, world!" << std::endl;
        try { throw exception{}; }
          catch (exception) { }
          catch (...) { }
        return 0;
      }
    EOS
    system "#{bin}/g++", "-o", "hello-cc", "hello-cc.cc"
    assert_equal "Hello, world!\n", `./hello-cc`

    (testpath/"test.f90").write <<~EOS
      integer,parameter::m=10000
      real::a(m), b(m)
      real::fact=0.5

      do concurrent (i=1:m)
        a(i) = a(i) + fact*b(i)
      end do
      write(*,"(A)") "Done"
      end
    EOS
    system "#{bin}/gfortran", "-o", "test", "test.f90"
    assert_equal "Done\n", `./test`

    if Hardware::CPU.intel?
      (testpath/"hello_d.d").write <<~EOS
        import std.stdio;
        int main()
        {
          writeln("Hello, world!");
          return 0;
        }
      EOS
      system "#{bin}/gdc", "-o", "hello-d", "hello_d.d"
      assert_equal "Hello, world!\n", `./hello-d`

      (testpath/"hello_ada.adb").write <<~EOS
        with Text_IO; use Text_IO;
        procedure hello is
        begin
          Put_Line("Hello, world!");
        end hello;
      EOS
      system bin/"gnat", "make", "hello_ada.adb"
      assert_equal "Hello, world!\n", `./hello_ada`
    end
  end
end
