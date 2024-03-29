class FontBhType1 < Formula
  desc "X.Org Fonts: font bh type1"
  homepage "https://gitlab.freedesktop.org/xorg/font/bh-type1"
  url "https://xorg.freedesktop.org/releases/individual/font/font-bh-type1-1.0.4.tar.xz"
  sha256 "19dec3ec06abde6bedd10094579e928be0f0fc3bdb4fbe93f4c69cce406d72a6"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/font-bh-type1-1.0.4"
    rebuild 1
    sha256 cellar: :any_skip_relocation, ventura: "0c68048d9ac03782338493081f3c3ff51be26a9e503a21a0c7845842454d57d3"
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
