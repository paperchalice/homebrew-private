class FontXfree86Type1 < Formula
  desc "X.Org Fonts: font xfree86 type1"
  homepage "https://gitlab.freedesktop.org/xorg/font/xfree86-type1"
  url "https://xorg.freedesktop.org/releases/individual/font/font-xfree86-type1-1.0.5.tar.xz"
  sha256 "a93c2c788a5ea1c002af7c8662cf9d9821fb1df51b8d2b2c5e0026dfdfea4837"
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
