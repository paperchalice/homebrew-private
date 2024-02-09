class Iceauth < Formula
  desc "ICE authority file utility"
  homepage "https://gitlab.freedesktop.org/xorg/app/iceauth"
  url "https://xorg.freedesktop.org/releases/individual/app/iceauth-1.0.9.tar.xz"
  sha256 "2cb9dfcb545683af77fb1029bea3fc52dcc8a0666f7b8b2d7373b6ed4c408c05"

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :build

  depends_on "libice"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
