class XorgServer < Formula
  desc "Xquartz X server"
  homepage "https://www.x.org"
  url "https://github.com/XQuartz/xorg-server.git",
  tag:      "XQuartz-2.8.1",
  revision: "93a0f39851f4b940d42e88460495ba52b166cb93"
  license "X11"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xorg-server-2.8.1"
    rebuild 1
    sha256 monterey: "3e2e9e389cb057730a5b6e5ab331fd50db1ac010732e2469d8430970c9aa3113"
  end

  depends_on "autoconf"    => :build
  depends_on "automake"    => :build
  depends_on "font-util"   => :build
  depends_on "libtool"     => :build
  depends_on "mesa"        => :build
  depends_on "pkgconf"     => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto"   => :build
  depends_on "xtrans"      => :build

  depends_on "libapplewm"
  depends_on "libxfixes"
  depends_on "libxfont2"
  depends_on "libxkbfile"
  depends_on "libxt"
  depends_on "pixman"
  depends_on "quartz-wm"
  depends_on "xkbcomp"
  depends_on "xkeyboardconfig"

  def install
    configure_args = std_configure_args + %W[
      --with-apple-applications-dir=#{libexec}
      --with-bundle-id-prefix=sh.brew
      --with-sha1=CommonCrypto
      --with-xkb-path=#{HOMEBREW_PREFIX}/share/X11/xkb
      --with-xkb-output=#{share}/X11/xkb/compiled
      --disable-devel-docs
      --without-doxygen
      --without-fop
      --without-xmlto
    ]

    system "autoreconf", "-i"
    system "./configure", *configure_args
    system "make"
    system "make", "install"
  end

  test do
    system "echo"
  end
end
