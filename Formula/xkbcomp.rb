class Xkbcomp < Formula
  desc "Keymap compiler"
  homepage "https://www.x.org"
  url "https://www.x.org/releases/individual/app/xkbcomp-1.4.5.tar.bz2"
  sha256 "6851086c4244b6fd0cc562880d8ff193fb2bbf1e141c73632e10731b31d4b05e"
  license "X11"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xkbcomp-1.4.5"
    sha256 cellar: :any, monterey: "bae7e7ec805219049897a79790d3684bac17e1324c1161ff2384f0aaf9af521d"
  end

  depends_on "pkgconf" => :build

  depends_on "libx11"
  depends_on "libxkbfile"

  def install
    configure_args = std_configure_args + %w[
      --disable-silent-rules
    ]
    system "./configure", *configure_args
    system "make"
    system "make", "install"
  end

  test do
    system "echo"
  end
end
