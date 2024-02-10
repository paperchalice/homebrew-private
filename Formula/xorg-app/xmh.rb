class Xmh < Formula
  desc "Graphical user interface to the MH Message Handling System"
  homepage "https://gitlab.freedesktop.org/xorg/app/xmh"
  url "https://xorg.freedesktop.org/releases/individual/app/xmh-1.0.4.tar.xz"
  sha256  "e82c425a4c4156eee2e344d2e952f3fd816e03973005cd656ec1e9acf6f329db"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "xbitmaps" => :build
  depends_on "xorgproto" => :build

  depends_on "libxaw"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
