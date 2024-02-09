class Xbacklight < Formula
  desc "Utility to adjust backlight brightness using RandR extension"
  homepage "https://gitlab.freedesktop.org/xorg/app/xbacklight"
  url "https://xorg.freedesktop.org/releases/individual/app/xbacklight-1.2.3.tar.bz2"
  sha256 "3a27f324777ae99fee476cfb2f064576fb8cba4eb77f97cda37adda1c1d39ade"
  license "X11"

  depends_on "pkgconf" => :build

  depends_on "libxcb"
  depends_on "xcb-util"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
