class Xkbevd < Formula
  desc "XKB event daemon"
  homepage "https://gitlab.freedesktop.org/xorg/app/xkbevd"
  url "https://xorg.freedesktop.org/releases/individual/app/xkbevd-1.1.5.tar.xz"
  sha256 "38357b702de9d3457c4ff75053390f457b84c4accc7f088101255c37c684926b"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libxkbfile"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
