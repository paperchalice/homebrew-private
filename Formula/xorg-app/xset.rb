class Xset < Formula
  desc "User preference utility for X servers"
  homepage "https://www.x.org/"
  url "https://www.x.org/releases/individual/app/xset-1.2.4.tar.bz2"
  sha256 "e4fd95280df52a88e9b0abc1fee11dcf0f34fc24041b9f45a247e52df941c957"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xset-1.2.4"
    sha256 cellar: :any, monterey: "c7743b6d3e5c98e9b8c44f6a379b44e8590c9b893937e50af41c9f413c0ec4eb"
  end

  depends_on "pkgconf"   => :build
  depends_on "xorgproto" => :build

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
