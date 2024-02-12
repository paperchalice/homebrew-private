class FontMuttMisc < Formula
  desc "X.Org Fonts: font mutt misc"
  homepage "https://gitlab.freedesktop.org/xorg/font/mutt-misc"
  url "https://xorg.freedesktop.org/releases/individual/font/font-mutt-misc-1.0.4.tar.xz"
  sha256 "b12359f4e12c23bcfcb448b918297e975fa91bef5293d88d3c25343cc768bb24"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/font-mutt-misc-1.0.4"
    rebuild 1
    sha256 cellar: :any_skip_relocation, ventura: "a570ead3ca0e423e02b9ae70f0580d01cf0dab9070151147d35bdbae87548a59"
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
