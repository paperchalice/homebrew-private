class Listres < Formula
  desc "Utility to list X resources"
  homepage "https://gitlab.freedesktop.org/xorg/app/listres"
  url "https://xorg.freedesktop.org/releases/individual/app/listres-1.0.5.tar.xz"
  sha256 "ce2a00bbe7d2eb8d75177006f343c80443a22d52570c48a43c6fe70ea074dc9d"
  license "X11"

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :build

  depends_on "libxaw"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
