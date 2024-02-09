class Fstobdf < Formula
  desc "Generate BDF font from X font server"
  homepage "https://gitlab.freedesktop.org/xorg/app/fstobdf"
  url "https://xorg.freedesktop.org/releases/individual/app/fstobdf-1.0.7.tar.xz"
  sha256 "2624cbf071ccca89c2a6dadd65004784f478b2ba1c62b8209e03909954f36b50"
  license "MIT-open-group"

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libfs"
  depends_on "libx11"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
