class FontBh100dpi < Formula
  desc "X.Org Fonts: font bh 100dpi"
  homepage "https://gitlab.freedesktop.org/xorg/font/bh-100dpi"
  url "https://xorg.freedesktop.org/releases/individual/font/font-bh-100dpi-1.0.4.tar.xz"
  sha256 "fd8f5efe8491faabdd2744808d3d4eafdae5c83e617017c7fddd2716d049ab1e"
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