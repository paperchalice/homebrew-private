class Fstobdf < Formula
  desc "Generate BDF font from X font server"
  homepage "https://gitlab.freedesktop.org/xorg/app/fstobdf"
  url "https://xorg.freedesktop.org/releases/individual/app/fstobdf-1.0.7.tar.xz"
  sha256 "2624cbf071ccca89c2a6dadd65004784f478b2ba1c62b8209e03909954f36b50"
  license "MIT-open-group"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/fstobdf-1.0.7"
    sha256 cellar: :any, ventura: "aa89f1beabc87eb5155ed78cd11d8c6cbe04182f34896a0c6eb0457ae1ad1ec7"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libfs"
  depends_on "libx11"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
