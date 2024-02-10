class Xwud < Formula
  desc "Utility to display an image in XWD format"
  homepage "https://gitlab.freedesktop.org/xorg/app/xwud"
  url "https://xorg.freedesktop.org/releases/individual/app/xwud-1.0.6.tar.xz"
  sha256 "64048cd15eba3cd9a3d2e3280650391259ebf6b529f2101d1a20f441038c1afe"
  license "MIT-open-group"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xwud-1.0.6"
    sha256 cellar: :any, ventura: "d3f6d8131d3539ff53fc1590db0a79376f685014f93fad0d35253fc98bec9549"
  end

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
