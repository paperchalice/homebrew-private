class Libapplewm < Formula
  desc "X11 font rasterisation library"
  homepage "https://www.x.org/"
  url "https://www.x.org/releases/individual/lib/libAppleWM-1.4.1.tar.bz2"
  sha256 "5e5c85bcd81152b7bd33083135bfe2287636e707bba25f43ea09e1422c121d65"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/libapplewm-1.4.1"
    sha256 cellar: :any, monterey: "8afd01d8d28ead06f69881605fef8bdd83b90d0c50c09d936a90cb80a4ca5fa2"
  end

  depends_on "pkgconf" => :build

  depends_on "libx11"
  depends_on "libxext"

  def install
    configure_args = std_configure_args + %w[
      --disable-silent-rules
      --disable-static
    ]

    inreplace "src/Makefile.in", "-F", "-F#{MacOS.sdk_path}"
    system "./configure", *configure_args
    system "make"
    system "make", "install"
  end

  test do
    system "echo"
  end
end
