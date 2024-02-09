class Mkcomposecache < Formula
  desc "X11 Compose file cache creator"
  homepage "https://gitlab.freedesktop.org/xorg/app/mkcomposecache"
  url "https://xorg.freedesktop.org/releases/individual/app/mkcomposecache-1.2.2.tar.xz"
  sha256 "1a58d8504ae52964d83904c49f5bcd47c160572b4e65bc445083ddc750a70055"
  license "HPND"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/mkcomposecache-1.2.2"
    sha256 cellar: :any, ventura: "d0c34fd9046fc6db5d2d754dd36d6245ced2f262786e191b555c2f7502adea1a"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build

  depends_on "libx11"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
