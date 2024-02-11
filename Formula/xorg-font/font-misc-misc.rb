class FontMiscMisc < Formula
  desc "X.Org Fonts: font misc misc"
  homepage "https://gitlab.freedesktop.org/xorg/font/misc-misc"
  url "https://xorg.freedesktop.org/releases/individual/font/font-misc-misc-1.0.0.tar.xz"
  sha256 "463c67beb6dd62ef97d85898cd935b68dfee8854dd8c2098914c96ce2e688758"
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
    inreplace "Makefile", "$(MKFONTSCALE)", "@echo", false
    system "make", "install"
  end

  test do
    system "echo"
  end
end
