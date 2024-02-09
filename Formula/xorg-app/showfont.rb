class Showfont < Formula
  desc "Utility to display data about a font from an X font server"
  homepage "https://gitlab.freedesktop.org/xorg/app/showfont"
  url "https://xorg.freedesktop.org/releases/individual/app/showfont-1.0.6.tar.xz"
  sha256 "2b9b9f06e65e095ed76ce560b701b9fc47fa63310ee706b54c8787af061d0e56"
  license "MIT"

  depends_on "pkgconf" => :build

  depends_on "libfs"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
