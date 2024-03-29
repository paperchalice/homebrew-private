class Viewres < Formula
  desc "Graphical class browser for the Athena Widget Set"
  homepage "https://gitlab.freedesktop.org/xorg/app/viewres"
  url "https://xorg.freedesktop.org/releases/individual/app/viewres-1.0.7.tar.xz"
  sha256 "b15a62085b1a10f55ae1cf17b7ded75b72b21be240c68071685db377c4afc628"
  license "X11"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/viewres-1.0.7"
    sha256 cellar: :any, ventura: "b8a478135716d873aa7ee20009719afba7f4bb2ad46c2f1f0da43101dee7cf44"
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
