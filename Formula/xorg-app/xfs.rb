class Xfs < Formula
  desc "X Font Server"
  homepage "https://gitlab.freedesktop.org/xorg/app/xfs"
  url "https://xorg.freedesktop.org/releases/individual/app/xfs-1.2.1.tar.xz"
  sha256 "3d8ac3e8add7eeb1dc199dff6c59f90a2dbe7aa4332c1e12192350f2cda1c1e6"
  license "X11"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xfs-1.2.1"
    sha256 ventura: "5f471e167bb86bb4d37b35a79ffe6b3d35901bc54fef93cf941d0a212104c55f"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build
  depends_on "xtrans" => :build

  depends_on "libxfont2"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
