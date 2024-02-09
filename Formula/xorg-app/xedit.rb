class Xedit < Formula
  desc "Simple graphical text editor using Athena Widgets"
  homepage "https://gitlab.freedesktop.org/xorg/app/xedit"
  url "https://xorg.freedesktop.org/releases/individual/app/xedit-1.2.3.tar.xz"
  sha256 "bdd33afeeca881622e55d2cf28f07b4a98f083d0a2573c0b9048f25bdd62db2f"
  license "BSD-3-Clause"

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
