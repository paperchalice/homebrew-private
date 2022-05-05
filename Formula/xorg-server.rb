class XorgServer < Formula
  desc "X Window System display server"
  homepage "https://www.x.org"
  url "https://gitlab.freedesktop.org/xorg/xserver.git",
    tag:      "xorg-server-21.1.3",
    revision: "85397cc2efe8fa73461cd21afe700829b2eca768"
  license "MIT"

  depends_on "font-util"   => :build
  depends_on "libxkbfile"  => :build
  depends_on "meson"       => :build
  depends_on "ninja"       => :build
  depends_on "pkg-config"  => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto"   => :build
  depends_on "xtrans"      => :build

  depends_on "libapplewm"
  depends_on "libxfixes"
  depends_on "libxfont2"
  depends_on "mesa"
  depends_on "pixman"
  depends_on "xcb-util"
  depends_on "xcb-util-image"
  depends_on "xcb-util-keysyms"
  depends_on "xcb-util-renderutil"
  depends_on "xcb-util-wm"
  depends_on "xkbcomp"
  depends_on "xkeyboardconfig"

  on_linux do
    depends_on "libepoxy"
    depends_on "libxcvt"
    depends_on "libxshmfence"
  end

  def install
    meson_args = std_meson_args + %W[
      -Dxephyr=true
      -Dxf86bigfont=true
      -Dxcsecurity=true

      -Dxkb_dir=#{HOMEBREW_PREFIX}/share/X11/xkb
      -Dxkb_bin_dir=#{Formula["xkbcomp"].opt_bin}
      -Dxkb_output_dir=#{HOMEBREW_PREFIX}/X11/xkb/compiled

      -Dbundle-id-prefix=sh.brew
      -Dbuilder_addr=#{tap.remote}
      -Dbuilder_string=#{tap.name}
    ]
    # macOS doesn't provide `authdes_cred` so `secure-rpc=false`
    # glamor needs GLX enabled `libepoxy` on macOS
    if OS.mac?
      meson_args += %W[
        -Dsecure-rpc=false
        -Dapple-applications-dir=#{libexec}
      ]
    end

    system "meson", "build", *meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
    bin.install_symlink bin/"Xquartz" => "X" if OS.mac?
  end

  def post_install
    if OS.mac?
      system "/System/Library/Frameworks/CoreServices.framework"\
             "/Frameworks/LaunchServices.framework/Support/lsregister",
            "-R", "-f", libexec/"X11.app"
    end
  end

  test do
    mkdir_p "Library/Logs/X11"
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <xcb/xcb.h>

      int main(void) {
        xcb_connection_t *connection = xcb_connect(NULL, NULL);
        int has_err = xcb_connection_has_error(connection);
        assert(has_err == 0);
        return 0;
      }
    EOS
    xcb = Formula["libxcb"]
    system ENV.cc, "./test.c", "-o", "test", "-I#{xcb.include}", "-L#{xcb.lib}", "-lxcb"

    ENV["DISPLAY"] = ":1"
    fork do
      exec bin/"X", ":1"
    end
    sleep 5
    system "./test"
  end
end
