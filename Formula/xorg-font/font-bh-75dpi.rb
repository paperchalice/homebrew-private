class FontBh75dpi < Formula
  desc "X.Org Fonts: font bh 75dpi"
  homepage "https://gitlab.freedesktop.org/xorg/font/bh-75dpi"
  url "https://xorg.freedesktop.org/releases/individual/font/font-bh-75dpi-1.0.4.tar.xz"
  sha256 "6026d8c073563dd3cbb4878d0076eed970debabd21423b3b61dd90441b9e7cda"
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
