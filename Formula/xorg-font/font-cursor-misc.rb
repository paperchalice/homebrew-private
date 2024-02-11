class FontCursorMisc < Formula
  desc "X.Org Fonts: font cursor misc"
  homepage "https://gitlab.freedesktop.org/xorg/font/cursor-misc"
  url "https://xorg.freedesktop.org/releases/individual/font/font-cursor-misc-1.0.4.tar.xz"
  sha256 "25d9c9595013cb8ca08420509993a6434c917e53ca1fec3f63acd45a19d4f982"
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
