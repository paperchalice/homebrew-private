class Xgamma < Formula
  desc "Utility to query and alter the gamma correction of a monitor"
  homepage "https://gitlab.freedesktop.org/xorg/app/xgamma"
  url "https://xorg.freedesktop.org/releases/individual/app/xgamma-1.0.7.tar.xz"
  sha256 "1c79dae85a8953a15f4fe5c2895a033307b43b8613456c87ec47b374b113bc8f"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xgamma-1.0.7"
    sha256 cellar: :any, ventura: "5146c59e8d0ab8988894c580e5b440f73e22d7ae77a722791efe759b9ee5e937"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libxxf86vm"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
