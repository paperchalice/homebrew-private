class Beforelight < Formula
  desc "Sample implementation of a screen saver for X servers"
  homepage "https://gitlab.freedesktop.org/xorg/app/beforelight"
  url "https://xorg.freedesktop.org/releases/individual/app/beforelight-1.0.6.tar.xz"
  sha256 "53f0bf085b7272ebbf626d1b9b0ad320d1a07bc1fe7f3ae260c86a71a857ad28"

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build
  depends_on "xorg-server" => :test

  depends_on "libxscrnsaver"
  depends_on "libxt"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
