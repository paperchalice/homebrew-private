class Showfont < Formula
  desc "Utility to display data about a font from an X font server"
  homepage "https://gitlab.freedesktop.org/xorg/app/showfont"
  url "https://xorg.freedesktop.org/releases/individual/app/showfont-1.0.6.tar.xz"
  sha256 "2b9b9f06e65e095ed76ce560b701b9fc47fa63310ee706b54c8787af061d0e56"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/showfont-1.0.6"
    sha256 cellar: :any, ventura: "9b81334b8078139fbb69cb5d7a56001f3aa41048559fa7b9be68a4125fa46865"
  end

  depends_on "pkgconf" => :build

  depends_on "libfs"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
