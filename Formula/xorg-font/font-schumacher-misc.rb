class FontSchumacherMisc < Formula
  desc "X.Org Fonts: font schumacher misc"
  homepage "https://gitlab.freedesktop.org/xorg/font/schumacher-misc"
  url "https://xorg.freedesktop.org/releases/individual/font/font-schumacher-misc-1.1.3.tar.xz"
  sha256 "8b849f0cdb1e55a34cc3dd8b0fb37443fabbc224d5ba44085569581244a68070"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/font-schumacher-misc-1.1.3"
    sha256 cellar: :any_skip_relocation, ventura: "6ca9e9c3acb3c663af583df290ffdf8e2b89cff90f9a6cc644115251b4885bc2"
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
