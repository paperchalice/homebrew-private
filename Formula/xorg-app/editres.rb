class Editres < Formula
  desc "Dynamic resource editor for X Toolkit applications"
  homepage "https://gitlab.freedesktop.org/xorg/app/editres"
  url "https://xorg.freedesktop.org/releases/individual/app/editres-1.0.8.tar.xz"
  sha256 "83cf5dffb1883635fd9c6a8dc48ff9e560f6c6d8ce1a0e929d5f409cba18b6f9"
  license "MIT-open-group"

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build
  depends_on "xorg-server" => :test

  depends_on "libxaw"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
