class Xclock < Formula
  desc "Analog/digital clock for X"
  homepage "https://gitlab.freedesktop.org/xorg/app/xclock"
  url "https://xorg.freedesktop.org/releases/individual/app/xclock-1.1.1.tar.xz"
  sha256 "df7ceabf8f07044a2fde4924d794554996811640a45de40cb12c2cf1f90f742c"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libxaw"
  depends_on "libxft"
  depends_on "libxkbfile"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
