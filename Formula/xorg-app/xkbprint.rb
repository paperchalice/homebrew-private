class Xkbprint < Formula
  desc "Generates a PostScript image of an XKB keyboard description"
  homepage "https://gitlab.freedesktop.org/xorg/app/xkbprint"
  url "https://xorg.freedesktop.org/releases/individual/app/xkbprint-1.0.6.tar.xz"
  sha256 "99cc9404f7b90289ae04944c0d98a208cc8b158492ad6481386e31d4d09aa7b0"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xkbprint-1.0.6"
    sha256 cellar: :any, ventura: "be4c0726a574f8bf68882ea4f1f66b05b776d5d18f61094e10ddd1736400b493"
  end

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
