class FontMiscEthiopic < Formula
  desc "X.Org Fonts: font misc ethiopic"
  homepage "https://gitlab.freedesktop.org/xorg/font/misc-ethiopic"
  url "https://xorg.freedesktop.org/releases/individual/font/font-misc-ethiopic-1.0.5.tar.xz"
  sha256 "4749a7e6e1a1eef6c91fcc9a04e8b1c0ed027d40c1599e5a6c93270d8469b612"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/font-misc-ethiopic-1.0.5"
    rebuild 1
    sha256 cellar: :any_skip_relocation, ventura: "58196eb1cbdcc09c7f3fe0f21ceb9b0957da15ed74ada8c9370b672d28394662"
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
