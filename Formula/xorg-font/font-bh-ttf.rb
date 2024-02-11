class FontBhTtf < Formula
  desc "X.Org Fonts: font bh ttf"
  homepage "https://gitlab.freedesktop.org/xorg/font/bh-ttf"
  url "https://xorg.freedesktop.org/releases/individual/font/font-bh-ttf-1.0.4.tar.xz"
  sha256 "85a5f90d00c48c2b06fd125ea8adbc8b8ee97429e3075081c8710926efec3a56"
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
