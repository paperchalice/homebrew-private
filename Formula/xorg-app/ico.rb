class Ico < Formula
  desc "Animation program for testing X11"
  homepage "https://gitlab.freedesktop.org/xorg/app/ico"
  url "https://xorg.freedesktop.org/releases/individual/app/ico-1.0.6.tar.xz"
  sha256 "38f369d431e753280fde70fa489cc94ce204f9f8eabd2f49fc7d32afa69f4405"
  license "MIT-open-group"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/ico-1.0.6"
    sha256 cellar: :any, ventura: "891ef1ecf96e05ee9e585908e84d2869aa4e88d4edc8c3faaacbd26add1e4705"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :build

  depends_on "libx11"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
