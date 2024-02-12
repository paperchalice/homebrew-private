class FontBitstream75dpi < Formula
  desc "X.Org Fonts: font bitstream 75dpi"
  homepage "https://gitlab.freedesktop.org/xorg/font/bitstream-75dpi"
  url "https://xorg.freedesktop.org/releases/individual/font/font-bitstream-75dpi-1.0.4.tar.xz"
  sha256 "aaeb34d87424a9c2b0cf0e8590704c90cb5b42c6a3b6a0ef9e4676ef773bf826"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/font-bitstream-75dpi-1.0.4"
    rebuild 1
    sha256 cellar: :any_skip_relocation, ventura: "345fa2c73996bc86339e47f017fe444fe383e137c79db64946f83ca34d2bea1a"
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
