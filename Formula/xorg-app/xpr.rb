class Xpr < Formula
  desc "Utility to print an X window dump from xwd"
  homepage "https://gitlab.freedesktop.org/xorg/app/xpr"
  url "https://xorg.freedesktop.org/releases/individual/app/xpr-1.1.0.tar.xz"
  sha256 "a0bbb11475366622632440b1c6f16d19964b4516483232fe5f46c169528557c5"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build
  depends_on "xorg-server" => :test

  depends_on "libxmu"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
