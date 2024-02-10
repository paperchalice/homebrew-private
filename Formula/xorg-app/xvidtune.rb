class Xvidtune < Formula
  desc "Video mode tuner client for XFree86-VidModeExtension"
  homepage "https://gitlab.freedesktop.org/xorg/app/xvidtune"
  url "https://xorg.freedesktop.org/releases/individual/app/xvidtune-1.0.4.tar.xz"
  sha256 "0d4eecd54e440cc11f1bdaaa23180fcf890f003444343f533f639086b05b2cc5"
  license "X11-distribute-modifications-variant"

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
