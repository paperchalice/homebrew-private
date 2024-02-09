class Xev < Formula
  desc "X event monitor"
  homepage "https://gitlab.freedesktop.org/xorg/app/xev"
  url "https://xorg.freedesktop.org/releases/individual/app/xev-1.2.5.tar.xz"
  sha256 "c9461a4389714e0f33974f9e75934bdc38d836a0f059b8dc089c7cbf2ce36ec1"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libxrandr"
  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
