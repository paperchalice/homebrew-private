class FontMiscCyrillic < Formula
  desc "X.Org Fonts: font misc cyrillic"
  homepage "https://gitlab.freedesktop.org/xorg/font/misc-cyrillic"
  url "https://xorg.freedesktop.org/releases/individual/font/font-misc-cyrillic-1.0.4.tar.xz"
  sha256 "76021a7f53064001914a57fd08efae57f76b68f0a24dca8ab1b245474ee8e993"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/font-misc-cyrillic-1.0.4"
    sha256 cellar: :any_skip_relocation, ventura: "961cf4cb1e606c686d1849f8ae7434d2d1e1ae8303a6decc1cfc6db09a09a947"
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
