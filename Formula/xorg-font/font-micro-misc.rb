class FontMicroMisc < Formula
  desc "X.Org Fonts: font micro misc"
  homepage "https://gitlab.freedesktop.org/xorg/font/micro-misc"
  url "https://xorg.freedesktop.org/releases/individual/font/font-micro-misc-1.0.4.tar.xz"
  sha256 "2ee0b9d6bd7ae849aff1bd82efab44a1b6b368fbb5e11d12ff7f015a3df6f943"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/font-micro-misc-1.0.4"
    rebuild 1
    sha256 cellar: :any_skip_relocation, ventura: "e4871c0c44ab20052570563774f128a5e915032105cb5a79550be6aff6f62b34"
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
