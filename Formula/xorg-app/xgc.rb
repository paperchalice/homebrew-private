class Xgc < Formula
  desc "Demo to show various features of the X11 core protocol graphics primitives"
  homepage "https://gitlab.freedesktop.org/xorg/app/xgc"
  url "https://xorg.freedesktop.org/releases/individual/app/xgc-1.0.6.tar.xz"
  sha256 "7b87bbdbce4ec858738a3b81b8a3943aff01036001e2a1d00bb5384392a8b240"
  license "MIT"

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
