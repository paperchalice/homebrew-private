class FontAdobe100dpi < Formula
  desc "X.Org Fonts: font adobe 100dpi"
  homepage "https://gitlab.freedesktop.org/xorg/font/adobe-100dpi"
  url "https://xorg.freedesktop.org/releases/individual/font/font-adobe-100dpi-1.0.4.tar.xz"
  sha256 "b67aff445e056328d53f9732d39884f55dd8d303fc25af3dbba33a8ba35a9ccf"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/font-adobe-100dpi-1.0.4"
    sha256 cellar: :any_skip_relocation, ventura: "d3951305dfcace1543b800a95099fa505f64e42b792e6716964010a7ab9098f8"
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
