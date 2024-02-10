class Xsm < Formula
  desc "X Session Manager"
  homepage "https://gitlab.freedesktop.org/xorg/app/xsm"
  url "https://xorg.freedesktop.org/releases/individual/app/xsm-1.0.5.tar.xz"
  sha256 "9c30fdaa3fc132e4ff201cfc478669056e6e15502e77df88df11fb94e4e6fb2d"
  license "MIT-open-group"

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
