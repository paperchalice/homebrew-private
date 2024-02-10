class Xload < Formula
  desc "System load average display for X"
  homepage "https://gitlab.freedesktop.org/xorg/app/xload"
  url "https://xorg.freedesktop.org/releases/individual/app/xload-1.1.4.tar.xz"
  sha256 "8346b99120db24e0f42920f7f12e23e9b1b407d3a66ce419990387b608373031"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xload-1.1.4"
    sha256 cellar: :any, ventura: "49e95a97d302867bd6c0bcacab6b7ffa9cd8e697f3905f1b8c696c0fd6b2081c"
  end

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
