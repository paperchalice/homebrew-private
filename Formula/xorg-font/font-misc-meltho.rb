class FontMiscMeltho < Formula
  desc "X.Org Fonts: font misc meltho"
  homepage "https://gitlab.freedesktop.org/xorg/font/misc-meltho"
  url "https://xorg.freedesktop.org/releases/individual/font/font-misc-meltho-1.0.4.tar.xz"
  sha256 "63be5ec17078898f263c24096a68b43ae5b06b88852e42549afa03d124d65219"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/font-misc-meltho-1.0.4"
    sha256 cellar: :any_skip_relocation, ventura: "fb1adb37e8766ce74fd10dfccadf6594d15e77643278425a1f916e867ed7933c"
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
