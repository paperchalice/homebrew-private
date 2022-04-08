class Libxfont2 < Formula
  desc "X11 font rasterisation library"
  homepage "https://www.x.org/"
  url "https://www.x.org/releases/individual/lib/libXfont2-2.0.5.tar.bz2"
  sha256 "aa7c6f211cf7215c0ab4819ed893dc98034363d7b930b844bb43603c2e10b53e"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/libxfont2-2.0.5"
    sha256 cellar: :any, monterey: "8b7baa768fa4ccfc22198b0e2fe819bfc2bcfec0dca071e3f7a1fc9224eb01ee"
  end

  depends_on "pkgconf"     => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto"   => [:build, :test]
  depends_on "xtrans"      => :build

  depends_on "freetype"
  depends_on "libfontenc"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    configure_args = std_configure_args + %W[
      --disable-silent-rules
      --disable-static
      --with-bundle-id-prefix=sh.homebrew
      --with-launchagents-dir=#{prefix}
      --with-launchdaemons-dir=#{prefix}
    ]
    system "./configure", *configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stddef.h>
      #include <X11/fonts/fontstruct.h>
      #include <X11/fonts/libxfont2.h>

      int main(int argc, char* argv[]) {
        xfont2_init(NULL);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lXfont2"
    system "./a.out"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
