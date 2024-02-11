class FontAdobeUtopia100dpi < Formula
  desc "X.Org Fonts: font adobe utopia 100dpi"
  homepage "https://gitlab.freedesktop.org/xorg/font/adobe-utopia-100dpi"
  url "https://xorg.freedesktop.org/releases/individual/font/font-adobe-utopia-100dpi-1.0.5.tar.xz"
  sha256 "fb84ec297a906973548ca59b7c6daeaad21244bec5d3fb1e7c93df5ef43b024b"
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
