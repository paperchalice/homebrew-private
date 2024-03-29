class FontBitstream100dpi < Formula
  desc "X.Org Fonts: font bitstream 100dpi"
  homepage "https://gitlab.freedesktop.org/xorg/font/bitstream-100dpi"
  url "https://xorg.freedesktop.org/releases/individual/font/font-bitstream-100dpi-1.0.4.tar.xz"
  sha256 "2d1cc682efe4f7ebdf5fbd88961d8ca32b2729968728633dea20a1627690c1a7"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/font-bitstream-100dpi-1.0.4"
    rebuild 1
    sha256 cellar: :any_skip_relocation, ventura: "fd83124b184e42c6de4868c1f396ddb6a2cf1fd627c7b2e47044e0fe4d89f8e7"
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
