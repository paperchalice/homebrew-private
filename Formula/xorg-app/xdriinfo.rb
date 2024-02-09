class Xdriinfo < Formula
  desc "Utility to query configuration information of X11 DRI drivers"
  homepage "https://gitlab.freedesktop.org/xorg/app/xdriinfo"
  url "https://xorg.freedesktop.org/releases/individual/app/xdriinfo-1.0.7.tar.xz"
  sha256 "dd838bae9d2b19ddd71fe6d30ed33abc7c85e19d223e79d35600db3fa44bf734"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libx11"
  depends_on "mesa"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
