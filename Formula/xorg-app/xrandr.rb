class Xrandr < Formula
  desc "Command-line interface to X11 RandR extension"
  homepage "https://gitlab.freedesktop.org/xorg/app/xrandr"
  url "https://xorg.freedesktop.org/releases/individual/app/xrandr-1.5.2.tar.xz"
  sha256 "c8bee4790d9058bacc4b6246456c58021db58a87ddda1a9d0139bf5f18f1f240"

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libxrandr"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
