class Xconsole < Formula
  desc "Displays /dev/console messages in an X window"
  homepage "https://gitlab.freedesktop.org/xorg/app/xconsole"
  url "https://xorg.freedesktop.org/releases/individual/app/xconsole-1.0.8.tar.xz"
  sha256 "7b4a6af068e40e2e6a4521d6f35c9253ec152c287d025fff9cc4c99f2586bba4"
  license "MIT-open-group"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xconsole-1.0.8"
    sha256 cellar: :any, ventura: "33f11d7d8c04969454bec7e6228d5bd1c8a7a44d55fa0354bc0df9cfa1abff01"
  end

  depends_on "pkgconf" => :build

  depends_on "libxaw"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
