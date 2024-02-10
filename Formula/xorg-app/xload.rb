class Xload < Formula
  desc "System load average display for X"
  homepage "https://gitlab.freedesktop.org/xorg/app/xload"
  url "https://xorg.freedesktop.org/releases/individual/app/xload-1.1.4.tar.xz"
  sha256 "8346b99120db24e0f42920f7f12e23e9b1b407d3a66ce419990387b608373031"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "gettext"
  depends_on "libxaw"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
