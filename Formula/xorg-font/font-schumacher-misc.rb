class FontSchumacherMisc < Formula
  desc "X.Org Fonts: font schumacher misc"
  homepage "https://gitlab.freedesktop.org/xorg/font/schumacher-misc"
  url "https://xorg.freedesktop.org/releases/individual/font/font-schumacher-misc-1.1.3.tar.xz"
  sha256 "8b849f0cdb1e55a34cc3dd8b0fb37443fabbc224d5ba44085569581244a68070"
  license "MIT"

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
