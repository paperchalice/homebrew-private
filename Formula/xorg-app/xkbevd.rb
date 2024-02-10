class Xkbevd < Formula
  desc "XKB event daemon"
  homepage "https://gitlab.freedesktop.org/xorg/app/xkbevd"
  url "https://xorg.freedesktop.org/releases/individual/app/xkbevd-1.1.5.tar.xz"
  sha256 "38357b702de9d3457c4ff75053390f457b84c4accc7f088101255c37c684926b"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xkbevd-1.1.5"
    sha256 cellar: :any, ventura: "542804a4d869e13d14f794ee1aaf30ef303e51be7add623004ddb21701868e43"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libxkbfile"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
