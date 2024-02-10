class Xrestop < Formula
  desc "Monitoring X Client server resource usage"
  homepage "https://gitlab.freedesktop.org/xorg/app/xrestop"
  url "https://xorg.freedesktop.org/releases/individual/app/xrestop-0.6.tar.xz"
  sha256 "2e2ec111c4b2798b5dc2dc2b3ec7af4f6b261946e903b8e14db046831d203b29"
  license "GPL-2.0-or-later"

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
