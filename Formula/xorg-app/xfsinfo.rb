class Xfsinfo < Formula
  desc "X font server information utility"
  homepage "https://gitlab.freedesktop.org/xorg/app/xfsinfo"
  url "https://xorg.freedesktop.org/releases/individual/app/xfsinfo-1.0.7.tar.xz"
  sha256 "92f3ca451cba7717eed15f80de3c123aa56c82a1ee7d6e9116ba513021b98874"
  license "MIT-open-group"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xfsinfo-1.0.7"
    sha256 cellar: :any, ventura: "56b25df0be35bcffe88a527f7942300c97550d8243063837fc4bab58b5854281"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libfs"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
