class FontScreenCyrillic < Formula
  desc "X.Org Fonts: font screen cyrillic"
  homepage "https://gitlab.freedesktop.org/xorg/font/screen-cyrillic"
  url "https://xorg.freedesktop.org/releases/individual/font/font-screen-cyrillic-1.0.5.tar.xz"
  sha256 "8f758bb8cd580c7e655487d1d0db69d319acae54d932b295d96d9d9b83fde5c0"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/font-screen-cyrillic-1.0.5"
    rebuild 1
    sha256 cellar: :any_skip_relocation, ventura: "5e5f3d6abd57ea9759b4f07389104368261f32a4132c28e23a28c254c646f23b"
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
