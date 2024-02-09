class Xbiff < Formula
  desc "Graphical notification of new e-mail"
  homepage "https://gitlab.freedesktop.org/xorg/app/xbiff"
  url "https://xorg.freedesktop.org/releases/individual/app/xbiff-1.0.5.tar.xz"
  sha256 "cffb10e2488b09695da8377f395a4fed6d33f5eb9691322ebaa969e8ead7b0c2"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xbiff-1.0.5"
    sha256 cellar: :any, ventura: "e6f43318bf6c23ddd614af7b59cb22f21d140d073a245582252038e36d3936c6"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libxaw"
  depends_on "xbitmaps"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
