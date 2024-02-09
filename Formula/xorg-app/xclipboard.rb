class Xclipboard < Formula
  desc "Clipboard management clients"
  homepage "https://gitlab.freedesktop.org/xorg/app/xclipboard"
  url "https://xorg.freedesktop.org/releases/individual/app/xclipboard-1.1.4.tar.xz"
  sha256 "f43d4560d1464e8ff58e850212f6bdb703989b66d599fb61f351b5f9e077f253"
  license "MIT-open-group"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xclipboard-1.1.4"
    sha256 cellar: :any, ventura: "60566480095cfaa9dc4c247056b80fbae7a7c74c216080b41e596bf4e5d8074b"
  end

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
