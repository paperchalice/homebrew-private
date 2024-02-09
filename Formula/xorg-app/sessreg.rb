class Sessreg < Formula
  desc "Utility to manage utmp & wtmp entries for X sessions"
  homepage "https://gitlab.freedesktop.org/xorg/app/sessreg"
  url "https://xorg.freedesktop.org/releases/individual/app/sessreg-1.1.3.tar.xz"
  sha256 "022acd5de8077dddc4f919961f79e102ecd5f3228a333681af5cd0e7344facc2"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/sessreg-1.1.3"
    sha256 cellar: :any_skip_relocation, ventura: "5097a27a9266c09418afdb758449a40beae1dad7a53eaee47313e07e45bf5623"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
