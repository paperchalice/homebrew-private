class Xcompmgr < Formula
  desc "Sample X compositing manager"
  homepage "https://gitlab.freedesktop.org/xorg/app/xcompmgr"
  url "https://xorg.freedesktop.org/releases/individual/app/xcompmgr-1.1.9.tar.xz"
  sha256 "4875b6698672d01eb3a5080bde6eac9a989d486a82226a2d5e23624f1527a6f0"
  license "MIT-CMU"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xcompmgr-1.1.9"
    sha256 cellar: :any, ventura: "a3523504cb891be899a72e3e7a14521f1d87df506449c33c3862aa4ed8753895"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libxcomposite"
  depends_on "libxdamage"
  depends_on "libxext"
  depends_on "libxrender"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
