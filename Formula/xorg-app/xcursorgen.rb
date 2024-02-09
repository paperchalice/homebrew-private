class Xcursorgen < Formula
  desc "Prepares X11 cursor sets for use with libXcursor"
  homepage "https://gitlab.freedesktop.org/xorg/app/xcursorgen"
  url "https://xorg.freedesktop.org/releases/individual/app/xcursorgen-1.0.8.tar.xz"
  sha256 "32b33ce27b4e285e64ff375731806bb7988cc626ff10915c65f1dc4da640cc9b"
  license "HPND"

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libpng"
  depends_on "libxcursor"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
