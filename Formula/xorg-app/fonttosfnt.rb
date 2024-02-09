class Fonttosfnt < Formula
  desc "Wraps a set of bdf or pcf bitmap fonts in a sfnt wrapper"
  homepage "https://gitlab.freedesktop.org/xorg/app/fonttosfnt"
  url "https://xorg.freedesktop.org/releases/individual/app/fonttosfnt-1.2.3.tar.xz"
  sha256 "aa7a93f240cbd0f5cdfe6be7c1b934b4f74d23de6257883a9f1b4bf21d7d61af"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :build

  depends_on "freetype"
  depends_on "libfontenc"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
