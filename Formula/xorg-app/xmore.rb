class Xmore < Formula
  desc "Plain text display program for the X Window System"
  homepage "https://gitlab.freedesktop.org/xorg/app/xmore"
  url "https://xorg.freedesktop.org/releases/individual/app/xmore-1.0.4.tar.xz"
  sha256 "7eb560dbc1de4e43c64fe491ad73907a29d734cca82a9ad82c7d3feb9cdb0a9a"
  license "MIT"

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
