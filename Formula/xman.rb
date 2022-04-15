class Xman < Formula
  desc "X manual page browser"
  homepage "https://www.x.org/"
  url "https://www.x.org/releases/individual/app/xman-1.1.5.tar.bz2"
  sha256 "4e3c2c7497e9734a6d3c8e1b6a364612892bb31e9f33076c9fdae7177ab60978"
  license "X11"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xman-1.1.5"
    sha256 monterey: "f785b98e4df63899d9e7fd7c63a989a68376a9ae57a2c04224db9c94714bb919"
  end

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
