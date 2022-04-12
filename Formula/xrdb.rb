class Xrdb < Formula
  desc "X11 server resource database utility"
  homepage "https://www.x.org/"
  url "https://www.x.org/releases/individual/app/xrdb-1.2.1.tar.bz2"
  sha256 "4f5d031c214ffb88a42ae7528492abde1178f5146351ceb3c05f3b8d5abee8b4"
  license "MIT"

  depends_on "pkgconf" => :build

  depends_on "libxmu"

  def install
    configure_args = std_configure_args + %w[
      --with-cpp=/usr/bin/cpp
    ]
    system "./configure", *configure_args
    system "make"
    system "make", "install"
  end

  test do
    system "echo"
  end
end
