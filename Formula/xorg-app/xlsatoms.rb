class Xlsatoms < Formula
  desc "Utility to list interned atoms defined on X server"
  homepage "https://gitlab.freedesktop.org/xorg/app/xlsatoms"
  url "https://www.x.org/releases/individual/app/xlsatoms-1.1.4.tar.xz"
  sha256 "f4bfa15f56c066d326a5d5b292646708f25b9247506840b9047cd2687dcc71b7"
  license "MIT-open-group"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xlsatoms-1.1.4"
    sha256 cellar: :any, ventura: "9384b0ee5daa6e2348b79812c07924f36b76784e6a0274ffd219d039dfc40654"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "xorg-server" => :test

  depends_on "libxcb"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
