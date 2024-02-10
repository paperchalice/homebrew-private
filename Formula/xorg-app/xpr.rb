class Xpr < Formula
  desc "Utility to print an X window dump from xwd"
  homepage "https://gitlab.freedesktop.org/xorg/app/xpr"
  url "https://xorg.freedesktop.org/releases/individual/app/xpr-1.1.0.tar.xz"
  sha256 "a0bbb11475366622632440b1c6f16d19964b4516483232fe5f46c169528557c5"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xpr-1.1.0"
    sha256 cellar: :any, ventura: "1c42cc9683251ca4e20d99d03686bd414d54c81ce0d4b118fd14b5abfa9a05d4"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build
  depends_on "xorg-server" => :test

  depends_on "libxmu"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
