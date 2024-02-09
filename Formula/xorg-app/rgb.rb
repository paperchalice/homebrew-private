class Rgb < Formula
  desc "X color name database and tools"
  homepage "https://gitlab.freedesktop.org/xorg/app/rgb"
  url "https://xorg.freedesktop.org/releases/individual/app/rgb-1.1.0.tar.xz"
  sha256 "fc03d7f56e5b2a617668167f8927948cce54f93097e7ccd9f056077f479ed37b"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :build

  depends_on "gdbm"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
