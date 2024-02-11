class FontSunMisc < Formula
  desc "X.Org Fonts: font sun misc"
  homepage "https://gitlab.freedesktop.org/xorg/font/sun-misc"
  url "https://xorg.freedesktop.org/releases/individual/font/font-sun-misc-1.0.4.tar.xz"
  sha256 "dd84dd116d927affa4fa0fa29727b3ecfc0f064238817c0a1e552a0ac384db9f"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/font-sun-misc-1.0.4"
    sha256 cellar: :any_skip_relocation, ventura: "d6389d7c7de98e1e31007428d1b9b89f246e8f487e36ab09598a0156fd77abff"
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
    system "make", "install"
  end

  test do
    system "echo"
  end
end
