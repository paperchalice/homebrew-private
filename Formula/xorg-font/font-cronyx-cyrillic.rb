class FontCronyxCyrillic < Formula
  desc "X.Org Fonts: font cronyx cyrillic"
  homepage "https://gitlab.freedesktop.org/xorg/font/cronyx-cyrillic"
  url "https://xorg.freedesktop.org/releases/individual/font/font-cronyx-cyrillic-1.0.4.tar.xz"
  sha256 "dc0781ce0dcbffdbf6aae1a00173a13403f92b0de925bca5a9e117e4e2d6b789"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/font-cronyx-cyrillic-1.0.4"
    sha256 cellar: :any_skip_relocation, ventura: "d66af4560ebc5bb1357ee6fe0ab9b5fd6fd0301995c22a5e4e40dc702aabf046"
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
