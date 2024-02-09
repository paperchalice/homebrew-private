class Mkcomposecache < Formula
  desc "X11 Compose file cache creator"
  homepage "https://gitlab.freedesktop.org/xorg/app/mkcomposecache"
  url "https://xorg.freedesktop.org/releases/individual/app/mkcomposecache-1.2.2.tar.xz"
  sha256 "1a58d8504ae52964d83904c49f5bcd47c160572b4e65bc445083ddc750a70055"
  license "HPND"

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build

  depends_on "libx11"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
