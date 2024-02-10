class Xwininfo < Formula
  desc "Utility to print information about windows on an X server"
  homepage "https://gitlab.freedesktop.org/xorg/app/xwininfo"
  url "https://xorg.freedesktop.org/releases/individual/app/xwininfo-1.1.6.tar.xz"
  sha256 "3518897c17448df9ba99ad6d9bb1ca0f17bc0ed7c0fd61281b34ceed29a9253f"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libx11"
  depends_on "libxcb"
  # TODO: depends_on "xcb-errors"
  # TODO: depends_on "xcb-iccm"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
