class Xlsclients < Formula
  desc "Utility to list client applications running on a display"
  homepage "https://gitlab.freedesktop.org/xorg/app/xlsclients"
  url "https://xorg.freedesktop.org/releases/individual/app/xlsclients-1.1.4.tar.gz"
  sha256 "0b46e8289413c3e7c437a95ecd6494f99d27406d3a0b724ef995a98cbd6c33e8"
  license "MIT"

  depends_on "pkgconf" => :build

  depends_on "libxcb"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
