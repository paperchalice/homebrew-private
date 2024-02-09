class Xcmsdb < Formula
  desc "Device Color Characterization utility for X Color Management System"
  homepage "https://gitlab.freedesktop.org/xorg/app/xcmsdb"
  url "https://xorg.freedesktop.org/releases/individual/app/xcmsdb-1.0.6.tar.xz"
  sha256 "3c77eec4537d5942bb0966973b787bfdaf7121f3125ffa81bb1c9708d4cf4f55"
  license "MIT-open-group"

  depends_on "pkgconf" => :build

  depends_on "libx11"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
