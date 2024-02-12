class Xscope < Formula
  desc "Program to monitor X11 Server/Client conversations"
  homepage "https://gitlab.freedesktop.org/xorg/app/xscope"
  url "https://xorg.freedesktop.org/releases/individual/app/xscope-1.4.4.tar.xz"
  sha256 "820d6708fce16e449a3cb8e62c2a0f49551e589d6595633deab82643e6a90c83"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xscope-1.4.4"
    sha256 cellar: :any_skip_relocation, ventura: "dcc3aee6972ccf1811e84c23d20076ef9a2c2725f8998f231525056a81bf4844"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build
  depends_on "xtrans" => :build

  depends_on "libxres"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
