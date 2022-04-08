class Xkbcomp < Formula
  desc "Keymap compiler"
  homepage "https://www.x.org"
  url "https://www.x.org/releases/individual/app/xkbcomp-1.4.5.tar.bz2"
  sha256 "6851086c4244b6fd0cc562880d8ff193fb2bbf1e141c73632e10731b31d4b05e"
  license "X11"

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
