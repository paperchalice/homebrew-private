class Xkbutils < Formula
  desc "Collection of small XKB utilities"
  homepage "https://gitlab.freedesktop.org/xorg/app/xkbutils"
  url "https://xorg.freedesktop.org/releases/individual/app/xkbutils-1.0.6.tar.xz"
  sha256 "31a2bbee1e09ccba01de92897b8f540b545de812f318d31de07bd3a5a75ee25e"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libxaw"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
