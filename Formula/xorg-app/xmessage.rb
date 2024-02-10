class Xmessage < Formula
  desc "Display a message or query in a window"
  homepage "https://gitlab.freedesktop.org/xorg/app/xmessage"
  url "https://xorg.freedesktop.org/releases/individual/app/xmessage-1.0.6.tar.xz"
  sha256 "d2eac545f137156b960877e052fcc8e29795ed735c02f7690fd7b439e6846a12"
  license "X11"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xmessage-1.0.6"
    sha256 cellar: :any, ventura: "a1d40efb195d8160ccd63070f2a594eb2fd5b0c89b5597732af6daac8335c5c5"
  end

  depends_on "pkgconf" => :build

  depends_on "libxaw"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
