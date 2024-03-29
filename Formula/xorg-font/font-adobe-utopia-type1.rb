class FontAdobeUtopiaType1 < Formula
  desc "X.Org Fonts: font adobe utopia type1"
  homepage "https://gitlab.freedesktop.org/xorg/font/adobe-utopia-type1"
  url "https://xorg.freedesktop.org/releases/individual/font/font-adobe-utopia-type1-1.0.5.tar.xz"
  sha256 "4cb280bc47693b07c5e00fd0e5ad5721aabebc0548c3f06774e5cc3cbcf75697"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/font-adobe-utopia-type1-1.0.5"
    rebuild 1
    sha256 cellar: :any_skip_relocation, ventura: "8057f718cb959ce098912b89440d82349404927bd23e00ca929b25f8fe97128f"
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
