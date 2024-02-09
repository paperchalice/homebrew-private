class Setxkbmap < Formula
  desc "Set keymaps, layouts, and options via the XKB"
  homepage "https://gitlab.freedesktop.org/xorg/app/setxkbmap"
  url "https://xorg.freedesktop.org/releases/individual/app/setxkbmap-1.3.4.tar.xz"
  sha256 "be8d8554d40e981d1b93b5ff82497c9ad2259f59f675b38f1b5e84624c07fade"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/setxkbmap-1.3.4"
    sha256 cellar: :any, ventura: "4628b7c4d13cf61fb656e78606e74159ce7561facd99c63fe440613a56b8edd7"
  end

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
