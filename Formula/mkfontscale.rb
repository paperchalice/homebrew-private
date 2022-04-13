class Mkfontscale < Formula
  desc "Create an index of scalable font files for X"
  homepage "https://www.x.org/"
  url "https://www.x.org/releases/individual/app/mkfontscale-1.2.2.tar.xz"
  sha256 "8ae3fb5b1fe7436e1f565060acaa3e2918fe745b0e4979b5593968914fe2d5c4"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/mkfontscale-1.2.2"
    sha256 cellar: :any, monterey: "68a921f902c034ba97ea6a989e0271b7c9e12fe5f5d9a048805c4e849228e9d5"
  end

  depends_on "pkgconf" => :build

  depends_on "freetype"
  depends_on "libfontenc"
  depends_on "libx11"

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system "echo"
  end
end
