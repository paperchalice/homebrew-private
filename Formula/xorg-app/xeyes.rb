class Xeyes < Formula
  desc "\"follow the mouse\" X demo, using the X SHAPE extension"
  homepage "https://gitlab.freedesktop.org/xorg/app/xeyes"
  url "https://xorg.freedesktop.org/releases/individual/app/xeyes-1.3.0.tar.xz"
  sha256 "0950c600bf33447e169a539ee6655ef9f36d6cebf2c1be67f7ab55dacb753023"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libxcb"
  depends_on "libxi"
  depends_on "libxmu"
  depends_on "libxrender"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
