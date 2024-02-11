class FontIsasMisc < Formula
  desc "X.Org Fonts: font isas misc"
  homepage "https://gitlab.freedesktop.org/xorg/font/isas-misc"
  url "https://xorg.freedesktop.org/releases/individual/font/font-isas-misc-1.0.4.tar.xz"
  sha256 "47e595bbe6da444b9f6fcaa26539abc7ba1989e23afa6cdc49e22e484cc438fc"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/font-isas-misc-1.0.4"
    sha256 cellar: :any_skip_relocation, ventura: "4b6d67055d24c7fe986416623c545d88cd39f777430f2b76c426e28cf65a7816"
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
