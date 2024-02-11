class FontMuttMisc < Formula
  desc "X.Org Fonts: font mutt misc"
  homepage "https://gitlab.freedesktop.org/xorg/font/mutt-misc"
  url "https://xorg.freedesktop.org/releases/individual/font/font-mutt-misc-1.0.4.tar.xz"
  sha256 "b12359f4e12c23bcfcb448b918297e975fa91bef5293d88d3c25343cc768bb24"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/font-mutt-misc-1.0.4"
    sha256 cellar: :any_skip_relocation, ventura: "f8d082aeb6f1186a54c37830cde687f90b67c079a0d6bebb0f503fc843b25d51"
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
