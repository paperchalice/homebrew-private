class Xlsclients < Formula
  desc "Utility to list client applications running on a display"
  homepage "https://gitlab.freedesktop.org/xorg/app/xlsclients"
  url "https://xorg.freedesktop.org/releases/individual/app/xlsclients-1.1.4.tar.gz"
  sha256 "0b46e8289413c3e7c437a95ecd6494f99d27406d3a0b724ef995a98cbd6c33e8"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xlsclients-1.1.4"
    sha256 cellar: :any, ventura: "f08d224dc228a7c8334f7cd57921ece71dabfa76609ab8dae32780f6d394c7fb"
  end

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
