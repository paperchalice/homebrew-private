class FontWinitzkiCyrillic < Formula
  desc "X.Org Fonts: font winitzki cyrillic"
  homepage "https://gitlab.freedesktop.org/xorg/font/winitzki-cyrillic"
  url "https://xorg.freedesktop.org/releases/individual/font/font-winitzki-cyrillic-1.0.4.tar.xz"
  sha256 "3b6d82122dc14776e3afcd877833a7834e1f900c53fc1c7bb2d67c781cfa97a8"
  license "MIT"

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
