class Xcalc < Formula
  desc "Scientific calculator X11 client"
  homepage "https://gitlab.freedesktop.org/xorg/app/xcalc"
  url "https://xorg.freedesktop.org/releases/individual/app/xcalc-1.1.2.tar.xz"
  sha256 "8578dfa1457e94289f6d6ed6146714307d8a73a1b54d2f42af1321b625fc1cd4"
  license "X11"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xcalc-1.1.2"
    sha256 cellar: :any, ventura: "80e5031cdd88866402e37230da1e83aeaa2174330b8e3a92498dd55cda8d9316"
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
