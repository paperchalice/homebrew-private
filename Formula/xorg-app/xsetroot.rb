class Xsetroot < Formula
  desc "Root window parameter setting utility for X"
  homepage "https://gitlab.freedesktop.org/xorg/app/xsetroot"
  url "https://xorg.freedesktop.org/releases/individual/app/xsetroot-1.1.3.tar.xz"
  sha256 "6081b45a9eb4426e045d259d1e144b32417fb635e5b96aa90647365ac96638d1"
  license "MIT-open-group"

  depends_on "pkgconf" => :build
  depends_on "xbitmaps" => :build
  depends_on "xorgproto" => :build

  depends_on "libxcursor"
  depends_on "libxmu"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
