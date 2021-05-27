class Giac < Formula
  desc "Free computer algebra system"
  homepage "https://www-fourier.ujf-grenoble.fr/~parisse/giac.html"
  url "http://www-fourier.ujf-grenoble.fr/~parisse/giac/giac-1.7.0.tar.bz2"
  sha256 "5b79b61373ee275435076300643342b05c96979772cb898cda31f4c2ead7a193"

  depends_on "pkg-config" => :build

  depends_on "fltk"
  depends_on "gettext"
  depends_on "glpk"
  depends_on "gmp"
  depends_on "gsl"
  depends_on "lapack"
  depends_on "libao"
  depends_on "libpng"
  depends_on "libsamplerate"
  depends_on "micropython"
  depends_on "ntl"
  depends_on "pari"
  depends_on "quickjs"

  uses_from_macos "curl"
  uses_from_macos "libiconv"

  def install
    ENV.append_to_cflags "-framework OpenGL -lintl -DHAVE_LIBMICROPYTHON -fpermissive"
    args = std_configure_args + %w[
      --enable-dl
      --enable-micropy=no
      --enable-png
    ]
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "echo"
  end
end
