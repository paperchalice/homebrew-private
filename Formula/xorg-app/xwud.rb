class Xwud < Formula
  desc "Utility to display an image in XWD format"
  homepage "https://gitlab.freedesktop.org/xorg/app/xwud"
  url "https://xorg.freedesktop.org/releases/individual/app/xwud-1.0.6.tar.xz"
  sha256 "64048cd15eba3cd9a3d2e3280650391259ebf6b529f2101d1a20f441038c1afe"
  license "MIT-open-group"

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libx11"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
