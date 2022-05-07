class Gfortran < Formula
  desc "GNU Fortran frontend"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-12.1.0/gcc-12.1.0.tar.xz"
  sha256 "62fd634889f31c02b64af2c468f064b47ad1ca78411c45abe6ac4b5f8dd19c7b"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  head "https://gcc.gnu.org/git/gcc.git", branch: "master"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/gfortran-11.3.0"
    sha256 monterey: "5ca2124625f21635f2bde7042c65e37375fc8620920529c664a20b2feb030661"
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

  def install
    # don't resolve symlinks
    inreplace "libiberty/make-relative-prefix.c", /(?<=, )1/, "0"

    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    languages = %w[c c++ fortran]

    pkgversion = "Homebrew GCC #{pkg_version}"
    triple = "#{Hardware::CPU.arch}-apple-#{OS.kernel_name.downcase}#{OS.kernel_version.major}"

    args = %W[
      --prefix=#{prefix}
      --disable-multilib
      --build=#{triple}
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
      --with-system-zlib
      --with-pkgversion=#{pkgversion}
      --with-bugurl=#{tap.issues_url}
      --with-sysroot=#{MacOS.sdk_path}
    ]

    mkdir "build" do
      system "../configure", *args

      system "make"
      system "make", "-C", "#{triple}/libgfortran", "install"
      system "make", "-C", "#{triple}/libgomp", "install-nodist_fincludeHEADERS"
      %w[common man info].each do |t|
        system "make", "-C", "gcc", "fortran.install-#{t}"
      end
      (lib/"gcc"/triple/version_suffix).install "gcc/f951"
      rm_rf lib.glob("libquadmath*")
    end

    rm bin/"gfortran"
    bin.install_symlink bin/"#{triple}-gfortran" => "gfortran"
    bin.install_symlink bin/"#{triple}-gfortran" => "fort77"

    gcc = Formula["paperchalice/private/gcc"]
    MachO::Tools.change_install_name lib/shared_library("libgfortran"),
      "#{lib}/#{shared_library("libquadmath", 0)}",
      "#{gcc.lib}/#{shared_library("libquadmath", 0)}"
  end

  test do
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
    system "gfortran", "-o", "test", "test.f90"
    assert_equal "Done\n", `./test`
  end
end
