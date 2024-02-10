class Xkbprint < Formula
  desc "Generates a PostScript image of an XKB keyboard description"
  homepage "https://gitlab.freedesktop.org/xorg/app/xkbprint"
  url "https://xorg.freedesktop.org/releases/individual/app/xkbprint-1.0.6.tar.xz"
  sha256 "99cc9404f7b90289ae04944c0d98a208cc8b158492ad6481386e31d4d09aa7b0"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libxkbfile"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
