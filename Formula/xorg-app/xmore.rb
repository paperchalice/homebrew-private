class Xmore < Formula
  desc "Plain text display program for the X Window System"
  homepage "https://gitlab.freedesktop.org/xorg/app/xmore"
  url "https://xorg.freedesktop.org/releases/individual/app/xmore-1.0.4.tar.xz"
  sha256 "7eb560dbc1de4e43c64fe491ad73907a29d734cca82a9ad82c7d3feb9cdb0a9a"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xmore-1.0.4"
    sha256 cellar: :any, ventura: "d7d881efa22fc738ff0d35ce3336477a8023bcddeb2499fa50d9a1698649b120"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build
  depends_on "xorg-server" => :test

  depends_on "libxaw"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
