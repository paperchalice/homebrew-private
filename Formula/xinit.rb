class Xinit < Formula
  desc "Start the X Window System server"
  homepage "https://www.x.org/"
  url "https://www.x.org/releases/individual/app/xinit-1.4.1.tar.bz2"
  sha256 "de9b8f617b68a70f6caf87da01fcf0ebd2b75690cdcba9c921d0ef54fa54abb9"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xinit-1.4.1"
    sha256 monterey: "027db18b72e4db1610c150e7e4a8fa483dbb3f4681b885d3209421f9d7e46ae6"
  end

  depends_on "pkgconf" => :build

  depends_on "libx11"

  def install
    configure_args = std_configure_args + %W[
      --disable-silent-rules
      --with-bundle-id-prefix=sh.brew
      --with-launchagents-dir=#{prefix}
      --with-launchdaemons-dir=#{prefix}
    ]
    system "./configure", *configure_args
    system "make"
    system "make", "install"
  end

  def plist_name
    "sh.brew.startx"
  end

  test do
    system "echo"
  end
end
