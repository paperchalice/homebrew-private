class Xdpyinfo < Formula
  desc "Display information utility for X"
  homepage "https://gitlab.freedesktop.org/xorg/app/xdpyinfo"
  url "https://xorg.freedesktop.org/releases/individual/app/xdpyinfo-1.3.4.tar.xz"
  sha256 "a8ada581dbd7266440d7c3794fa89edf6b99b8857fc2e8c31042684f3af4822b"
  license "MIT-open-group"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xdpyinfo-1.3.4"
    sha256 cellar: :any, ventura: "6fd709cc2f9c40b54a41bd9253eb96eff575e8397add337d60d6d89651ae9011"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libxtst"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
