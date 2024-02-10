class Xkbutils < Formula
  desc "Collection of small XKB utilities"
  homepage "https://gitlab.freedesktop.org/xorg/app/xkbutils"
  url "https://xorg.freedesktop.org/releases/individual/app/xkbutils-1.0.6.tar.xz"
  sha256 "31a2bbee1e09ccba01de92897b8f540b545de812f318d31de07bd3a5a75ee25e"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xkbutils-1.0.6"
    sha256 cellar: :any, ventura: "73d09288e6a63ba670e7e27e6484ec701064154ecc76792e940726d47b31cd6e"
  end

  depends_on "pkgconf" => :build
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
