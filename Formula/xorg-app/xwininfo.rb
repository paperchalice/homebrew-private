class Xwininfo < Formula
  desc "Utility to print information about windows on an X server"
  homepage "https://gitlab.freedesktop.org/xorg/app/xwininfo"
  url "https://xorg.freedesktop.org/releases/individual/app/xwininfo-1.1.6.tar.xz"
  sha256 "3518897c17448df9ba99ad6d9bb1ca0f17bc0ed7c0fd61281b34ceed29a9253f"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xwininfo-1.1.6"
    sha256 cellar: :any, ventura: "18ae07a81bbb94050a7ec58746e4fdd3f5256f514641c4aae4ca0c1dcf40779a"
  end

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
