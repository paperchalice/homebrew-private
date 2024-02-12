class FontIbmType1 < Formula
  desc "X.Org Fonts: font ibm type1"
  homepage "https://gitlab.freedesktop.org/xorg/font/ibm-type1"
  url "https://xorg.freedesktop.org/releases/individual/font/font-ibm-type1-1.0.4.tar.xz"
  sha256 "c4395e95ba46d40c4ad1737e91cac20c0ab75411329b60db5d99fed92b60ce7f"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/font-ibm-type1-1.0.4"
    rebuild 1
    sha256 cellar: :any_skip_relocation, ventura: "5097641e8601c44a89b271b65f6a19790ec440807f923c9e3983556ae0d7a3b9"
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
