class Xfontsel < Formula
  desc "X font selection client"
  homepage "https://gitlab.freedesktop.org/xorg/app/xfontsel"
  url "https://xorg.freedesktop.org/releases/individual/app/xfontsel-1.1.0.tar.xz"
  sha256 "17052c3357bbfe44b8468675ae3d099c2427ba9fcac10540aef524ae4d77d1b4"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "gettext"
  depends_on "libxaw"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
