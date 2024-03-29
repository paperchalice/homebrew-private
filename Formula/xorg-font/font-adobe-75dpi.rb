class FontAdobe75dpi < Formula
  desc "X.Org Fonts: font adobe 75dpi"
  homepage "https://gitlab.freedesktop.org/xorg/font/adobe-75dpi"
  url "https://xorg.freedesktop.org/releases/individual/font/font-adobe-75dpi-1.0.4.tar.xz"
  sha256 "1281a62dbeded169e495cae1a5b487e1f336f2b4d971d92911c59c103999b911"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/font-adobe-75dpi-1.0.4"
    rebuild 2
    sha256 cellar: :any_skip_relocation, ventura: "0a591b585dff1440dc976977a882c7f348ed42f5040360620ac213a9e673698e"
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
