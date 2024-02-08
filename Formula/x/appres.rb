class Appres < Formula
  desc "Utility to list X application resource database"
  homepage "https://gitlab.freedesktop.org/xorg/app/appres"
  url "https://xorg.freedesktop.org/releases/individual/app/appres-1.0.6.tar.xz"
  sha256 "8b2257e2a0a1ad8330323aec23f07c333075d7fe4e6efd88e0c18fba8223590b"
  license "MIT-open-group"

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build
  depends_on "xorg-server" => :test

  depends_on "libxt"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    fork do
      exec Formula["xorg-server"].bin/"Xvfb", ":1"
    end
    ENV["DISPLAY"] = ":1"
    sleep 10
    system bin/"appres", "-V"
  end
end
