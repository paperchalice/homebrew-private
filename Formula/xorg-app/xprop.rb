class Xprop < Formula
  desc "Command-line tool to display properties for X windows"
  homepage "https://gitlab.freedesktop.org/xorg/app/xprop"
  url "https://xorg.freedesktop.org/releases/individual/app/xprop-1.2.6.tar.xz"
  sha256 "580b8525b12ecc0144aa16c88b0aafa76d2e799b44c8c6c50f9ce92788b5586e"
  license "MIT-open-group"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xprop-1.2.6"
    sha256 cellar: :any, ventura: "051de65d682be8c4e288463e3a902a3a918d2ef367a6807e9538d1e003498179"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build
  depends_on "xorg-server" => :test

  depends_on "libx11"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
