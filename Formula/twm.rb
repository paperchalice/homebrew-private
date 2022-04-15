class Twm < Formula
  desc "Tab Window Manager for X11"
  homepage "https://www.x.org/"
  url "https://www.x.org/releases/individual/app/twm-1.0.12.tar.xz"
  sha256 "aaf201d4de04c1bb11eed93de4bee0147217b7bdf61b7b761a56b2fdc276afe4"
  license "X11"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/twm-1.0.12"
    sha256 monterey: "33e5242f34836d678ecabd0b35eefe5edea8b5eeb0b337a48594273f7a5268c1"
  end

  depends_on "pkgconf" => :build

  depends_on "libxmu"

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system "echo"
  end
end
