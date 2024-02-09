class Xedit < Formula
  desc "Simple graphical text editor using Athena Widgets"
  homepage "https://gitlab.freedesktop.org/xorg/app/xedit"
  url "https://xorg.freedesktop.org/releases/individual/app/xedit-1.2.3.tar.xz"
  sha256 "bdd33afeeca881622e55d2cf28f07b4a98f083d0a2573c0b9048f25bdd62db2f"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xedit-1.2.3"
    sha256 ventura: "0915d312d970ab39dce028e2d626b9c169016ff635777b4ab176e5369b04d4f3"
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
