class FontDecMisc < Formula
  desc "X.Org Fonts: font dec misc"
  homepage "https://gitlab.freedesktop.org/xorg/font/dec-misc"
  url "https://xorg.freedesktop.org/releases/individual/font/font-dec-misc-1.0.4.tar.xz"
  sha256 "82d968201d8ff8bec0e51dccd781bb4d4ebf17e11004944279bdc0201e161af7"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/font-dec-misc-1.0.4"
    sha256 cellar: :any_skip_relocation, ventura: "e467d7072c25332d53948cb477968fae477fa7ca549fbf9b37505eb4671462ea"
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
