class Xprop < Formula
  desc "Command-line tool to display properties for X windows"
  homepage "https://gitlab.freedesktop.org/xorg/app/xprop"
  url "https://xorg.freedesktop.org/releases/individual/app/xprop-1.2.6.tar.xz"
  sha256 "580b8525b12ecc0144aa16c88b0aafa76d2e799b44c8c6c50f9ce92788b5586e"
  license "MIT-open-group"

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build
  depends_on "xorg-server" => :test

  depends_on "libx11"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
