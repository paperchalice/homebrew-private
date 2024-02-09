class Oclock < Formula
  desc "Round X clock"
  homepage "https://gitlab.freedesktop.org/xorg/app/oclock"
  url "https://xorg.freedesktop.org/releases/individual/app/oclock-1.0.5.tar.xz"
  sha256 "8f09979655e889d056b7a1e50b57f38b32529453e756b53ec659070fb3c3965c"
  license "MIT-open-group"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/oclock-1.0.5"
    sha256 cellar: :any, ventura: "1a1b8210247562e817b1018ef4039510d1fcc2c50096544aa278b8f8381cc696"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :build
  depends_on "xorg-server" => :test

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
