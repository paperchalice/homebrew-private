class FontMiscMisc < Formula
  desc "X.Org Fonts: font misc misc"
  homepage "https://gitlab.freedesktop.org/xorg/font/misc-misc"
  url "https://xorg.freedesktop.org/releases/individual/font/font-misc-misc-1.1.3.tar.xz"
  sha256 "79abe361f58bb21ade9f565898e486300ce1cc621d5285bec26e14b6a8618fed"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/font-misc-misc-1.1.3"
    sha256 cellar: :any_skip_relocation, ventura: "1f30cefa782a084663505793d1668f09aa62889716a948a1a8e9d71fd7bb73f4"
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
