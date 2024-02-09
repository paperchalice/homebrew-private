class Xdm < Formula
  desc "X Display Manager with support for XDMCP, host chooser"
  homepage "https://gitlab.freedesktop.org/xorg/app/xdm"
  url "https://xorg.freedesktop.org/releases/individual/app/xdm-1.1.14.tar.xz"
  sha256 "3e9bf25636797ec9e595286dd6820ecc33901439f07705eaf608ecda012c3d5f"
  license "X11-distribute-modifications-variant"

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "libxaw"
  depends_on "libxdmcp"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "echo"
  end
end
