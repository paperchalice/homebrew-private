class Xfd < Formula
  desc "X font display utility"
  homepage "https://gitlab.freedesktop.org/xorg/app/xfd"
  url "https://xorg.freedesktop.org/releases/individual/app/xfd-1.1.4.tar.xz"
  sha256 "d5470ffb66fd45a1e1b03d6df01f12d4caf0cf675cde0345cda237243e9076fd"
  license "MIT-open-group"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xfd-1.1.4"
    sha256 cellar: :any, ventura: "4234c75c8bf38ca9b7e89ec0a9f13399142aec1c758275330e402edcdb469ec9"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libxaw"
  depends_on "libxft"
  depends_on "libxkbfile"
  depends_on "libxmu"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
