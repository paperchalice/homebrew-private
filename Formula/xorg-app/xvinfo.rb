class Xvinfo < Formula
  desc "Utility to print out X-Video extension adaptor information"
  homepage "https://gitlab.freedesktop.org/xorg/app/xvinfo"
  url "https://xorg.freedesktop.org/releases/individual/app/xvinfo-1.1.5.tar.xz"
  sha256 "3ede71ecb26d9614ccbc6916720285e95a2c7e0c5e19b8570eaaf72ad7c5c404"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libxv"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
