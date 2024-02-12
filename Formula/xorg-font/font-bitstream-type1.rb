class FontBitstreamType1 < Formula
  desc "X.Org Fonts: font bitstream type1"
  homepage "https://gitlab.freedesktop.org/xorg/font/bitstream-type1"
  url "https://xorg.freedesktop.org/releases/individual/font/font-bitstream-type1-1.0.4.tar.xz"
  sha256 "de2f238b4cd72db4228a0ba67829d76a2b7c039e22993d66a722ee385248c628"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/font-bitstream-type1-1.0.4"
    rebuild 1
    sha256 cellar: :any_skip_relocation, ventura: "fc3e62bdc009330d8195e6ad80f57ba9bdf5a6069a24c556063fe9ff0ace9555"
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
