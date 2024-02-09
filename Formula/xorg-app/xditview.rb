class Xditview < Formula
  desc "Display ditroff output in an X window"
  homepage "https://gitlab.freedesktop.org/xorg/app/xditview"
  url "https://xorg.freedesktop.org/releases/individual/app/xditview-1.0.7.tar.xz"
  sha256 "039e2d447fa409d4bb25c4e87cf09b4d4b3eff2d3af5aee8e7e52165a3259fd7"
  license "X11"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xditview-1.0.7"
    sha256 cellar: :any, ventura: "83328f3ef1975450b461133b307527339588301f7a80b43b2ce8de1bf26082c8"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "fontconfig"
  depends_on "libxaw"
  depends_on "libxrender"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
