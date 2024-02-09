class Xconsole < Formula
  desc "Displays /dev/console messages in an X window"
  homepage "https://gitlab.freedesktop.org/xorg/app/xconsole"
  url "https://xorg.freedesktop.org/releases/individual/app/xconsole-1.0.8.tar.xz"
  sha256 "7b4a6af068e40e2e6a4521d6f35c9253ec152c287d025fff9cc4c99f2586bba4"
  license "MIT-open-group"

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
