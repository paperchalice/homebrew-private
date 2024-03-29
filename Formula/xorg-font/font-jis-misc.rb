class FontJisMisc < Formula
  desc "X.Org Fonts: font jis misc"
  homepage "https://gitlab.freedesktop.org/xorg/font/jis-misc"
  url "https://xorg.freedesktop.org/releases/individual/font/font-jis-misc-1.0.4.tar.xz"
  sha256 "78d1eff6c471f7aa6802a26d62cccf51d8e5185586406d9b6e1ee691b0bffad0"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/font-jis-misc-1.0.4"
    rebuild 1
    sha256 cellar: :any_skip_relocation, ventura: "d355a93bf4225a215f067a39e1885eeec7a93419f75957a89560fb369a15ab56"
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
