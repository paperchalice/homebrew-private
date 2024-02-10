class Xsm < Formula
  desc "X Session Manager"
  homepage "https://gitlab.freedesktop.org/xorg/app/xsm"
  url "https://xorg.freedesktop.org/releases/individual/app/xsm-1.0.5.tar.xz"
  sha256 "9c30fdaa3fc132e4ff201cfc478669056e6e15502e77df88df11fb94e4e6fb2d"
  license "MIT-open-group"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xsm-1.0.5"
    sha256 ventura: "e5003eab0bd2affe34539a8dc29b8418f62b1bef19e6bc7a0e56c7405a77dfcc"
  end

  depends_on "pkgconf" => :build
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
