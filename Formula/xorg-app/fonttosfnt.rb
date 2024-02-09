class Fonttosfnt < Formula
  desc "Wraps a set of bdf or pcf bitmap fonts in a sfnt wrapper"
  homepage "https://gitlab.freedesktop.org/xorg/app/fonttosfnt"
  url "https://xorg.freedesktop.org/releases/individual/app/fonttosfnt-1.2.3.tar.xz"
  sha256 "aa7a93f240cbd0f5cdfe6be7c1b934b4f74d23de6257883a9f1b4bf21d7d61af"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/fonttosfnt-1.2.3"
    sha256 cellar: :any, ventura: "dcf3f60456449c16eef74e9bf09d6de042bb1ab0412342ae7049c0456a2308ca"
  end

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
