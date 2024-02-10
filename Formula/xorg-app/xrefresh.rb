class Xrefresh < Formula
  desc "Utility to refresh all or part of an X screen"
  homepage "https://gitlab.freedesktop.org/xorg/app/xrefresh"
  url "https://xorg.freedesktop.org/releases/individual/app/xrefresh-1.0.7.tar.xz"
  sha256 "a9f1d635f2f42283d0174e94d09ab69190c227faa5ab542bfe15ed9607771b1e"
  license "MIT"

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
