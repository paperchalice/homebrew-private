class Smproxy < Formula
  desc "Session Manager Proxy"
  homepage "https://gitlab.freedesktop.org/xorg/app/smproxy"
  url "https://xorg.freedesktop.org/releases/individual/app/smproxy-1.0.7.tar.xz"
  sha256 "4aa99237cc9dab7d87ce9bc7cca4116674a853b5f08dfe3f9db1bb2b2cf9f305"
  license "MIT-open-group"

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
