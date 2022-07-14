class XorgServer < Formula
  desc "X Window System display server"
  homepage "https://www.x.org"
  url "https://gitlab.freedesktop.org/xorg/xserver.git",
    tag:      "xorg-server-21.1.3",
    revision: "85397cc2efe8fa73461cd21afe700829b2eca768"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xorg-server-21.1.3"
    rebuild 1
    sha256 monterey: "ab91d95c8ead23fe8ee61f5fff244714ae6c5ceb1f3ecc04d45c4c46efa72c19"
  end

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
    depends_on "libdrm"
    depends_on "libepoxy"
    depends_on "libxcvt"
    depends_on "libxshmfence"
    depends_on "systemd"
  end

  def install
    font_path = %w[misc TTF OTF Type1 100dpi 75dpi].map do |p|
      HOMEBREW_PREFIX/"share/fonts/X11"/p
    end
    if OS.mac?
      font_path += %W[
        #{HOMEBREW_PREFIX}/share/system_fonts
        /Library/Fonts
        /System/Library/Fonts
      ]
    end
    meson_args = std_meson_args + %W[
      -Dxephyr=true
      -Dxf86bigfont=true
      -Dxcsecurity=true

      -Dmodule_dir=#{HOMEBREW_PREFIX}/xorg/modules
      -Ddefault_font_path=#{font_path.join ","}
      -Dxkb_dir=#{HOMEBREW_PREFIX}/share/X11/xkb
      -Dxkb_bin_dir=#{Formula["xkbcomp"].opt_bin}
      -Dxkb_output_dir=#{HOMEBREW_PREFIX}/X11/xkb/compiled

      -Dbundle-id-prefix=homebrew.mxcl
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
    sleep 10
    system "./test"
  end
end
