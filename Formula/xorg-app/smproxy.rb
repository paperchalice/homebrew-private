class Smproxy < Formula
  desc "Session Manager Proxy"
  homepage "https://gitlab.freedesktop.org/xorg/app/smproxy"
  url "https://xorg.freedesktop.org/releases/individual/app/smproxy-1.0.7.tar.xz"
  sha256 "4aa99237cc9dab7d87ce9bc7cca4116674a853b5f08dfe3f9db1bb2b2cf9f305"
  license "MIT-open-group"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/smproxy-1.0.7"
    sha256 cellar: :any, ventura: "ff1833d42772518b72db21e80a0cb2daefb3cffd88b8cf63af44b6fa0bd5312b"
  end

  depends_on "pkgconf" => :build

  depends_on "libxmu"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
