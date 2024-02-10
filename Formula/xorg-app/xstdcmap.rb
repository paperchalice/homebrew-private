class Xstdcmap < Formula
  desc "X standard colormap utility"
  homepage "https://gitlab.freedesktop.org/xorg/app/xstdcmap"
  url "https://xorg.freedesktop.org/releases/individual/app/xstdcmap-1.0.5.tar.xz"
  sha256 "365847e379398499ec9ad9a299cc47a0d6e7feba9546dfd4e5b422204b5ac180"
  license "MIT-open-group"

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libxmu"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
