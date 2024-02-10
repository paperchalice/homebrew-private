class Xrestop < Formula
  desc "Monitoring X Client server resource usage"
  homepage "https://gitlab.freedesktop.org/xorg/app/xrestop"
  url "https://xorg.freedesktop.org/releases/individual/app/xrestop-0.6.tar.xz"
  sha256 "2e2ec111c4b2798b5dc2dc2b3ec7af4f6b261946e903b8e14db046831d203b29"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xrestop-0.6"
    sha256 cellar: :any, ventura: "1555b2d3d4ed83c3f35ba2e53b5587d7e2fe7848a6ed2490a1e93b5c956ab197"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libxres"

  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
