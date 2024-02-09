class Transset < Formula
  desc "Utility for setting opacity/transparency property on a window"
  homepage "https://gitlab.freedesktop.org/xorg/app/transset"
  url "https://xorg.freedesktop.org/releases/individual/app/transset-1.0.3.tar.xz"
  sha256 "1fe38f30dddd0dd88b5f05f121e5c6632315915468cd6a49d65fc0b17aa3e6fe"
  license "MIT-open-group"

  depends_on "pkgconf" => :build
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
