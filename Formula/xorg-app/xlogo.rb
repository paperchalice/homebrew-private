class Xlogo < Formula
  desc "X manual page browser"
  homepage "https://www.x.org/"
  url "https://www.x.org/releases/individual/app/xlogo-1.0.5.tar.bz2"
  sha256 "633d7a3aa5df61e4e643b740e5799664741ab1a0ba40593e54fcd15dc30f378e"
  license "X11"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xlogo-1.0.5"
    sha256 cellar: :any, monterey: "f233135d0da26f645ac8493b4ed3e35ce60a1b65e381e66fa6d1f2c92314c95f"
  end

  depends_on "pkgconf"     => :build
  depends_on "util-macros" => :build

  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxaw"
  depends_on "libxext"
  depends_on "libxft"
  depends_on "libxmu"
  depends_on "libxrender"
  depends_on "libxt"

  def install
    configure_args = std_configure_args + %w[
      --with-render
    ]

    system "./configure", *configure_args
    system "make"
    system "make", "install"
  end

  test do
    system "echo"
  end
end
