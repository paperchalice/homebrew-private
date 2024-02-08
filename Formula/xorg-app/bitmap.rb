class Bitmap < Formula
  desc "X bitmap editor and converter utilities"
  homepage "https://gitlab.freedesktop.org/xorg/app/bitmap"
  url "https://xorg.freedesktop.org/releases/individual/app/bitmap-1.1.1.tar.xz"
  sha256 "63d42eb63fe48198b39344af49949e5e424cc62ce8d722781fdad4a4fa3426e6"
  license "MIT-open-group"

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "xbitmaps" => :build
  depends_on "xorgproto" => :build
  depends_on "xorg-server" => :test

  depends_on "libxaw"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
    (include/"X11/bitmaps").install include/"X11/bitmaps/Stipple" => "Stipple2"
  end

  test do
    system "echo"
  end
end
