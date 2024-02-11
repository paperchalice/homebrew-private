class FontArabicMisc < Formula
  desc "X.Org Fonts: font arabic misc"
  homepage "https://gitlab.freedesktop.org/xorg/font/arabic-misc"
  url "https://xorg.freedesktop.org/releases/individual/font/font-arabic-misc-1.0.4.tar.xz"
  sha256 "46ffe61b52c78a1d2dca70ff20a9f2d84d69744639cab9a085c7a7ee17663467"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/font-arabic-misc-1.0.4"
    sha256 cellar: :any_skip_relocation, ventura: "cec4bcbaad67efb0d756158f971ed29e0003844c7e6a68b9b585b4fd0bd01c5b"
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
    system "make", "install"
  end

  test do
    system "echo"
  end
end
