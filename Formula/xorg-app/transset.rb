class Transset < Formula
  desc "Utility for setting opacity/transparency property on a window"
  homepage "https://gitlab.freedesktop.org/xorg/app/transset"
  url "https://xorg.freedesktop.org/releases/individual/app/transset-1.0.3.tar.xz"
  sha256 "1fe38f30dddd0dd88b5f05f121e5c6632315915468cd6a49d65fc0b17aa3e6fe"
  license "MIT-open-group"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/transset-1.0.3"
    sha256 cellar: :any, ventura: "0eb98678797689609457e1d221266b0596ede2976cc56623814edfc30888d4d2"
  end

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
