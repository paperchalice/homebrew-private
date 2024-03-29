class FontSonyMisc < Formula
  desc "X.Org Fonts: font sony misc"
  homepage "https://gitlab.freedesktop.org/xorg/font/sony-misc"
  url "https://xorg.freedesktop.org/releases/individual/font/font-sony-misc-1.0.4.tar.xz"
  sha256 "e6b09f823fccb06e0bd0b2062283b6514153323bd8a7486e9c2e3f55ab84946b"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/font-sony-misc-1.0.4"
    rebuild 1
    sha256 cellar: :any_skip_relocation, ventura: "214f7ee8e3f87e40300977fc632439c6f5d3b1abe49114c91b33f5fa1f29b1e4"
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
