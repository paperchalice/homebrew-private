class Constype < Formula
  desc "Utility to print type of Sun console"
  homepage "https://gitlab.freedesktop.org/xorg/app/constype"
  url "https://xorg.freedesktop.org/releases/individual/app/constype-1.0.5.tar.xz"
  sha256 "82d61d468214aed1a087207e6a8b6c6d35a1807345a51bf12a45e68e11a9ee74"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "splint" => :build
  depends_on "util-macros" => :build
  depends_on "xorg-server" => :test

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
