class Xclipboard < Formula
  desc "Clipboard management clients"
  homepage "https://gitlab.freedesktop.org/xorg/app/xclipboard"
  url "https://xorg.freedesktop.org/releases/individual/app/xclipboard-1.1.4.tar.xz"
  sha256 "f43d4560d1464e8ff58e850212f6bdb703989b66d599fb61f351b5f9e077f253"
  license "MIT-open-group"

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libxaw"
  depends_on "libxkbfile"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
