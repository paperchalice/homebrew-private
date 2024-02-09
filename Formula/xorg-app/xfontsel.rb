class Xfontsel < Formula
  desc "X font selection client"
  homepage "https://gitlab.freedesktop.org/xorg/app/xfontsel"
  url "https://xorg.freedesktop.org/releases/individual/app/xfontsel-1.1.0.tar.xz"
  sha256 "17052c3357bbfe44b8468675ae3d099c2427ba9fcac10540aef524ae4d77d1b4"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xfontsel-1.1.0"
    sha256 cellar: :any, ventura: "d2148538f19403e8eed52902c9346792d7a9b0d8ac0c4dfb00426c57c9d0b23e"
  end

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
