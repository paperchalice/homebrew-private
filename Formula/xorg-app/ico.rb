class Ico < Formula
  desc "Animation program for testing X11"
  homepage "https://gitlab.freedesktop.org/xorg/app/ico"
  url "https://xorg.freedesktop.org/releases/individual/app/ico-1.0.6.tar.xz"
  sha256 "38f369d431e753280fde70fa489cc94ce204f9f8eabd2f49fc7d32afa69f4405"
  license "MIT-open-group"

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
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
