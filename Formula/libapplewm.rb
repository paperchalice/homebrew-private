class Libapplewm < Formula
  desc "Xlib-based library for the Apple-WM extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/releases/individual/lib/libAppleWM-1.4.1.tar.bz2"
  sha256 "5e5c85bcd81152b7bd33083135bfe2287636e707bba25f43ea09e1422c121d65"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/libapplewm-1.4.1"
    sha256 cellar: :any, monterey: "8afd01d8d28ead06f69881605fef8bdd83b90d0c50c09d936a90cb80a4ca5fa2"
  end

  depends_on "pkgconf" => :build

  depends_on "libx11"
  depends_on "libxext"

  def install
    configure_args = std_configure_args + %w[
      --disable-silent-rules
      --disable-static
    ]

    inreplace "src/Makefile.in", "-F", "-F#{MacOS.sdk_path}"
    system "./configure", *configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <X11/Xlib.h>
      #include <X11/extensions/applewm.h>
      #include <stdio.h>

      int main(void) {
        Display* disp = XOpenDisplay(NULL);
        if (disp == NULL) {
          fprintf(stderr, "Unable to connect to display\\n");
          return 0;
        }

        XAppleWMSetFrontProcess(disp);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test",
      "-I#{include}", "-L#{lib}", "-L#{Formula["libx11"].lib}",
      "-lX11", "-lAppleWM"
    system "./test"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
