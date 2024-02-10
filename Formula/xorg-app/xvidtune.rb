class Xvidtune < Formula
  desc "Video mode tuner client for XFree86-VidModeExtension"
  homepage "https://gitlab.freedesktop.org/xorg/app/xvidtune"
  url "https://xorg.freedesktop.org/releases/individual/app/xvidtune-1.0.4.tar.xz"
  sha256 "0d4eecd54e440cc11f1bdaaa23180fcf890f003444343f533f639086b05b2cc5"
  license "X11-distribute-modifications-variant"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xvidtune-1.0.4"
    sha256 cellar: :any, ventura: "28c8fa6941524280b7d7a0a390628028befc41924e32f85436e0608c287a0a51"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libxaw"
  depends_on "libxxf86vm"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
