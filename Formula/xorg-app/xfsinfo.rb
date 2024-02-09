class Xfsinfo < Formula
  desc "X font server information utility"
  homepage "https://gitlab.freedesktop.org/xorg/app/xfsinfo"
  url "https://xorg.freedesktop.org/releases/individual/app/xfsinfo-1.0.7.tar.xz"
  sha256 "92f3ca451cba7717eed15f80de3c123aa56c82a1ee7d6e9116ba513021b98874"
  license "MIT-open-group"

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libfs"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
