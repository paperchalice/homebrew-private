class Listres < Formula
  desc "Utility to list X resources"
  homepage "https://gitlab.freedesktop.org/xorg/app/listres"
  url "https://xorg.freedesktop.org/releases/individual/app/listres-1.0.5.tar.xz"
  sha256 "ce2a00bbe7d2eb8d75177006f343c80443a22d52570c48a43c6fe70ea074dc9d"
  license "X11"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/listres-1.0.5"
    sha256 cellar: :any, ventura: "6f9da3dc308e9c93af4eca0cf1a116deeb36d510186d2f356437ab31fb1a7499"
  end

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
