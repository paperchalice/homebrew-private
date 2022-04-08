class Libapplewm < Formula
  desc "X11 font rasterisation library"
  homepage "https://www.x.org/"
  url "https://www.x.org/releases/individual/lib/libAppleWM-1.4.1.tar.bz2"
  sha256 "5e5c85bcd81152b7bd33083135bfe2287636e707bba25f43ea09e1422c121d65"
  license "MIT"

  depends_on "pkgconf" => :build

  depends_on "libx11"
  depends_on "libxext"

  def install
    configure_args = std_configure_args + %w[
      --disable-silent-rules
      --disable-static
    ]

    inreplace "src/Makefile.in", "-F", "-F#{MacOS.sdk_path}"
    system "./configure", *configure_args
    system "make"
    system "make", "install"
  end

  test do
    system "echo"
  end
end
