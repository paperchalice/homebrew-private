class FontBhLucidatypewriter100dpi < Formula
  desc "X.Org Fonts: font bh lucidatypewriter 100dpi"
  homepage "https://gitlab.freedesktop.org/xorg/font/bh-lucidatypewriter-100dpi"
  url "https://xorg.freedesktop.org/releases/individual/font/font-bh-lucidatypewriter-100dpi-1.0.4.tar.xz"
  sha256 "76ec09eda4094a29d47b91cf59c3eba229c8f7d1ca6bae2abbb3f925e33de8f2"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/font-bh-lucidatypewriter-100dpi-1.0.4"
    rebuild 1
    sha256 cellar: :any_skip_relocation, ventura: "3b57f87e3a72ade29b71714d418e0c2a42985bd8472b32d14f9ec069dc667abb"
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
