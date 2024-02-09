class Oclock < Formula
  desc "Round X clock"
  homepage "https://gitlab.freedesktop.org/xorg/app/oclock"
  url "https://xorg.freedesktop.org/releases/individual/app/oclock-1.0.5.tar.xz"
  sha256 "8f09979655e889d056b7a1e50b57f38b32529453e756b53ec659070fb3c3965c"
  license "MIT-open-group"

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
