class Rgb < Formula
  desc "X color name database and tools"
  homepage "https://gitlab.freedesktop.org/xorg/app/rgb"
  url "https://xorg.freedesktop.org/releases/individual/app/rgb-1.1.0.tar.xz"
  sha256 "fc03d7f56e5b2a617668167f8927948cce54f93097e7ccd9f056077f479ed37b"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/rgb-1.1.0"
    sha256 cellar: :any_skip_relocation, ventura: "62986c47d9654b91c3fca906960ea744fbfc392aa4895b4215e9d1eabb069c7e"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :build

  depends_on "gdbm"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
