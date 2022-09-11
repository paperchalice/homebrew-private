class Gfortran < Formula
  desc "GNU Fortran frontend"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-12.2.0/gcc-12.2.0.tar.xz"
  sha256 "e549cf9cf3594a00e27b6589d4322d70e0720cdd213f39beb4181e06926230ff"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  head "https://gcc.gnu.org/git/gcc.git", branch: "master"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/gfortran-12.2.0"
    sha256 cellar: :any, monterey: "5e635c4d256636bc62df0cec0c72b6866d19587827bb6449799b79557f9bf807"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on "python" => :build

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
    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    languages = %w[c c++ fortran]

    pkgversion = "Homebrew GCC #{pkg_version}"
    triple = "#{Hardware::CPU.arch}-apple-#{OS.kernel_name.downcase}#{OS.kernel_version.major}"

    args = %W[
      --prefix=#{HOMEBREW_PREFIX}
      --disable-multilib
      --disable-bootstrap
      --build=#{triple}
      --enable-nls
      --enable-host-shared
      --enable-checking=release
      --enable-libphobos
      --enable-languages=#{languages.join ","}
      --libexecdir=#{HOMEBREW_PREFIX}/lib
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
      system "make", "-C", "#{triple}/libgfortran", "prefix=#{prefix}", "install"
      system "make", "-C", "#{triple}/libgomp", "prefix=#{prefix}", "install-nodist_fincludeHEADERS"
      %w[common man info].each do |t|
        system "make", "-C", "gcc", "prefix=#{prefix}", "fortran.install-#{t}"
      end
      (lib/"gcc"/triple/version_suffix).install "gcc/f951"
      rm_rf lib.glob("libquadmath*")
    end

    rm bin/"gfortran"
    bin.install_symlink bin/"#{triple}-gfortran" => "gfortran"
    bin.install_symlink bin/"#{triple}-gfortran" => "fort77"
    rm info/"dir"
    [man1, info].each { |d| system "gzip", *Dir[d/"*"] }
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
