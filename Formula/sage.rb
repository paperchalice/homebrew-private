class Sage < Formula
  desc "Free open-source mathematics software"
  homepage "https://www.sagemath.org/"
  url "http://mirrors.mit.edu/sage/src/sage-9.3.tar.gz"
  sha256 "ab57d72579ed8f66bf806055d2cf8d42c45c2d8d0a82469c8bacdacb2ebab31e"
  license "GPL-3.0-only"

  depends_on "cmake"      => :build
  depends_on "m4"         => :build
  depends_on "perl"       => :build
  depends_on "pkg-config" => :build
  depends_on "python"     => :build
  depends_on "tox"        => :build

  depends_on "arb"
  depends_on "bdw-gc"
  depends_on "boost"
  depends_on "flint"
  depends_on "fplll"
  depends_on "freetype"
  depends_on "gcc"
  depends_on "gd"
  depends_on "glpk"
  depends_on "gmp"
  depends_on "gpatch"
  depends_on "graphviz"
  depends_on "gsl"
  depends_on "igraph"
  depends_on "isl"
  depends_on "libatomic_ops"
  depends_on "libmpc"
  depends_on "libpng"
  depends_on "mpfi"
  depends_on "mpfr"
  depends_on "nauty"
  depends_on "ntl"
  depends_on "openblas"
  depends_on "openssl"
  depends_on "pcre"
  depends_on "ppl"
  depends_on "r"
  depends_on "suite-sparse"
  depends_on "tcl-tk"
  depends_on "xz"
  depends_on "yasm"
  depends_on "zeromq"
  depends_on "zlib"

  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    ENV.cxx11
    args = %W[
      --prefix=#{prefix}
    ]
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "echo"
  end
end
