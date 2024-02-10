class Xwd < Formula
  desc "Utility to dump an image of an X window in XWD format"
  homepage "https://gitlab.freedesktop.org/xorg/app/xwd"
  url "https://xorg.freedesktop.org/releases/individual/app/xwd-1.0.9.tar.xz"
  sha256 "dc121b84947eb4a3d1131bff1e9844cfa2124d95b47b35f9932340fa931fbd3f"
  license "MIT-open-group"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xwd-1.0.9"
    sha256 cellar: :any, ventura: "889725013f8284afc556556a5dcf14363b3850cee4c86b8d3ad24f2c0a698cf4"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libxkbfile"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
