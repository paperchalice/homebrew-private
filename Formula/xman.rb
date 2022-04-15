class Xman < Formula
  desc "X manual page browser"
  homepage "https://www.x.org/"
  url "https://www.x.org/releases/individual/app/xman-1.1.5.tar.bz2"
  sha256 "4e3c2c7497e9734a6d3c8e1b6a364612892bb31e9f33076c9fdae7177ab60978"
  license "X11"

  depends_on "pkgconf" => :build

  depends_on "libxaw"

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system "echo"
  end
end
