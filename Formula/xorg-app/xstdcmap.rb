class Xstdcmap < Formula
  desc "X standard colormap utility"
  homepage "https://gitlab.freedesktop.org/xorg/app/xstdcmap"
  url "https://xorg.freedesktop.org/releases/individual/app/xstdcmap-1.0.5.tar.xz"
  sha256 "365847e379398499ec9ad9a299cc47a0d6e7feba9546dfd4e5b422204b5ac180"
  license "MIT-open-group"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xstdcmap-1.0.5"
    sha256 cellar: :any, ventura: "9aaf43a9b6216ecb2a5932f2dbc4756befd8c1c380d19f5751a137dcd64e3b4f"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libxmu"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
