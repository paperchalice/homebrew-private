class Xlsfonts < Formula
  desc "Utility to list core protocol fonts on an X server"
  homepage "https://gitlab.freedesktop.org/xorg/app/xlsfonts"
  url "https://xorg.freedesktop.org/releases/individual/app/xlsfonts-1.0.7.tar.xz"
  sha256 "7b726945a967b44c35cddee5edd74802907a239ce2e2e515730b8a32c8e50465"
  license "MIT-open-group"

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libx11"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
