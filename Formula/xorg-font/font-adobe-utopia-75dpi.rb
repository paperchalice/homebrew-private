class FontAdobeUtopia75dpi < Formula
  desc "X.Org Fonts: font adobe utopia 75dpi"
  homepage "https://gitlab.freedesktop.org/xorg/font/adobe-utopia-75dpi"
  url "https://xorg.freedesktop.org/releases/individual/font/font-adobe-utopia-75dpi-1.0.5.tar.xz"
  sha256 "a726245932d0724fa0c538c992811d63d597e5f53928f4048e9caf5623797760"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/font-adobe-utopia-75dpi-1.0.5"
    rebuild 1
    sha256 cellar: :any_skip_relocation, ventura: "94645100a83749f1ac3ee7aad9afa2eb4bcd9c5a2ce739235f57bc50fbad267e"
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
    inreplace "Makefile", "$(MKFONTSCALE)", "@echo", false
    system "make", "install"
  end

  test do
    system "echo"
  end
end
