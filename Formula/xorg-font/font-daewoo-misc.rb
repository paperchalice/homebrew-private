class FontDaewooMisc < Formula
  desc "X.Org Fonts: font daewoo misc"
  homepage "https://gitlab.freedesktop.org/xorg/font/daewoo-misc"
  url "https://xorg.freedesktop.org/releases/individual/font/font-daewoo-misc-1.0.4.tar.xz"
  sha256 "f63c8b3dc8f30098cb868b7db2c2c0c8b5b3fd2cefd044035697a43d4c7a4f31"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/font-daewoo-misc-1.0.4"
    rebuild 1
    sha256 cellar: :any_skip_relocation, ventura: "8608d883fe933b8e359296afaf4fba165599eab47a4c48705cca240e7ca2901b"
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
