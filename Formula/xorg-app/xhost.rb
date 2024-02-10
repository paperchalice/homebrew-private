class Xhost < Formula
  desc "X server access control program"
  homepage "https://gitlab.freedesktop.org/xorg/app/xhost"
  url "https://xorg.freedesktop.org/releases/individual/app/xhost-1.0.9.tar.xz"
  sha256 "ea86b531462035b19a2e5e01ef3d9a35cca7d984086645e2fc844d8f0e346645"
  license "MIT"

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
