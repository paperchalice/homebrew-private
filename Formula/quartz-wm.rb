class QuartzWm < Formula
  desc "XQuartz window-manager"
  homepage "https://www.xquartz.org"
  url "https://gitlab.freedesktop.org/xorg/app/quartz-wm.git",
    tag:      "quartz-wm-1.3.2",
    revision: "6f0fc2cfa5b81a64a6db5317aec5850458c5065d"
  license "APSL-2.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/quartz-wm-1.3.2"
    sha256 cellar: :any, monterey: "4138972b8a60dd9c420c62f6bc9a9088d5735de7cafdcd98d45f96e42b7d5733"
  end

  depends_on "autoconf"    => :build
  depends_on "automake"    => :build
  depends_on "libtool"     => :build
  depends_on "pkgconf"     => :build
  depends_on "util-macros" => :build

  depends_on "libapplewm"
  depends_on "libxinerama"
  depends_on "libxrandr"
  depends_on "pixman"

  def install
    inreplace "src/quartz-wm.h", "#undef Picture",
              "#include <ApplicationServices/ApplicationServices.h>\n#undef Picture"
    configure_args = std_configure_args + %w[
      --disable-silent-rules
      --disable-static
      --with-bundle-id-prefix=sh.brew
      --enable-xplugin-dock-support
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