class Setxkbmap < Formula
  desc "Set keymaps, layouts, and options via the XKB"
  homepage "https://gitlab.freedesktop.org/xorg/app/setxkbmap"
  url "https://xorg.freedesktop.org/releases/individual/app/setxkbmap-1.3.4.tar.xz"
  sha256 "be8d8554d40e981d1b93b5ff82497c9ad2259f59f675b38f1b5e84624c07fade"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libxkbfile"
  depends_on "libxrandr"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
