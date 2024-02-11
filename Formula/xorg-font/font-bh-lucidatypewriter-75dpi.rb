class FontBhLucidatypewriter75dpi < Formula
  desc "X.Org Fonts: font bh lucidatypewriter 75dpi"
  homepage "https://gitlab.freedesktop.org/xorg/font/bh-lucidatypewriter-75dpi"
  url "https://xorg.freedesktop.org/releases/individual/font/font-bh-lucidatypewriter-75dpi-1.0.4.tar.xz"
  sha256 "864e2c39ac61f04f693fc2c8aaaed24b298c2cd40283cec12eee459c5635e8f5"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/font-bh-lucidatypewriter-75dpi-1.0.4"
    sha256 cellar: :any_skip_relocation, ventura: "f18318520ef5b3dc14b4e04aa82c2b1dc407ab2c8a09b8593431d41b1d98e3a4"
  end

  depends_on "bdftopcf" => :build
  depends_on "font-util" => :build
  depends_on "fontconfig" => :build
  depends_on "mkfontscale" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "bzip2" => :build

  def install
    configure_args = std_configure_args + %W[
      --with-fontrootdir=#{share}/fonts/X11
      --with-compression=bzip2
    ]

    system "./configure", *configure_args
    inreplace "Makefile", "$(MKFONTDIR)", "@echo"
    system "make", "install"
  end

  test do
    system "echo"
  end
end
