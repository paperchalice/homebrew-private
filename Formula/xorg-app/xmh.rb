class Xmh < Formula
  desc "Graphical user interface to the MH Message Handling System"
  homepage "https://gitlab.freedesktop.org/xorg/app/xmh"
  url "https://xorg.freedesktop.org/releases/individual/app/xmh-1.0.4.tar.xz"
  sha256  "e82c425a4c4156eee2e344d2e952f3fd816e03973005cd656ec1e9acf6f329db"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xmh-1.0.4"
    sha256 cellar: :any, ventura: "b97bee52513616234d6695d32eae8ea6232cc3bf86f57f789083c4200d45570a"
  end

  depends_on "pkgconf" => :build
  depends_on "xbitmaps" => :build
  depends_on "xorgproto" => :build

  depends_on "libxaw"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
