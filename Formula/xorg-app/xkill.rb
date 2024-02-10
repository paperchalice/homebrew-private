class Xkill < Formula
  desc "Utility to forcibly terminate X11 clients"
  homepage "https://gitlab.freedesktop.org/xorg/app/xkill"
  url "https://xorg.freedesktop.org/releases/individual/app/xkill-1.0.6.tar.xz"
  sha256 "e5a8aa78c475677b11504646da8d93dacc30744258076a2ca418a24438aeb907"
  license "MIT-open-group"

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libxmu"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
