class Xrefresh < Formula
  desc "Utility to refresh all or part of an X screen"
  homepage "https://gitlab.freedesktop.org/xorg/app/xrefresh"
  url "https://xorg.freedesktop.org/releases/individual/app/xrefresh-1.0.7.tar.xz"
  sha256 "a9f1d635f2f42283d0174e94d09ab69190c227faa5ab542bfe15ed9607771b1e"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xrefresh-1.0.7"
    sha256 cellar: :any, ventura: "59d514e281002ff2bd851b483121681bf01d0858dff988a2568336dd93d5a68d"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libx11"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
