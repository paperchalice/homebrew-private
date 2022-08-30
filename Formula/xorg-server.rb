class XorgServer < Formula
  desc "X Window System display server"
  homepage "https://www.x.org"
  url "https://www.x.org/releases/individual/xserver/xorg-server-21.1.4.tar.xz"
  sha256 "5cc4be8ee47edb58d4a90e603a59d56b40291ad38371b0bd2471fc3cbee1c587"
  license all_of: ["MIT", "APSL-2.0"]

  depends_on "font-util"   => :build
  depends_on "libxkbfile"  => :build
  depends_on "meson"       => :build
  depends_on "ninja"       => :build
  depends_on "pkg-config"  => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto"   => :build
  depends_on "xtrans"      => :build

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

  on_macos do
    depends_on "libapplewm"
  end

  on_linux do
    depends_on "dbus"
    depends_on "libdrm"
    depends_on "libepoxy"
    depends_on "libxcvt"
    depends_on "libxshmfence"
    depends_on "nettle"
    depends_on "systemd"
  end

  def install
    # ChangeLog contains some non relocatable strings
    rm "ChangeLog"
    # set proper font dir
    inreplace "meson.build", "fontutil_dep.get_pkgconfig_variable('fontrootdir')",
              "'#{HOMEBREW_PREFIX}/share/fonts/X11'"
    # avoid setting `xkb_dir`
    ENV.remove "PKG_CONFIG_PATH", Formula["xkbcomp"].opt_lib/"pkgconfig"
    system "echo", "$PKG_CONFIG_PATH"
    system "false"
    meson_args = %W[
      --prefix=#{HOMEBREW_PREFIX}
      --buildtype=release
      --wrap-mode=nofallback

      -Dxephyr=true
      -Dxf86bigfont=true
      -Dxcsecurity=true

      -Dbundle-id-prefix=#{Formula["xinit"].plist_name.chomp ".startx"}
      -Dbuilder_addr=#{tap.remote}
      -Dbuilder_string=#{tap.name}
    ]
    # macOS doesn't provide `authdes_cred` so `secure-rpc=false`
    # glamor needs GLX with `libepoxy` on macOS
    if OS.mac?
      meson_args += %W[
        -Dsecure-rpc=false
        -Dapple-applications-dir=#{HOMEBREW_PREFIX}/libexec
      ]
    end

    destdir = buildpath/"dest"
    system "meson", "build", *meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build", "--destdir", destdir
    prefix.install Dir["#{destdir}#{HOMEBREW_PREFIX}/*"]
    # follow https://github.com/XQuartz/XQuartz/blob/main/compile.sh#L955
    bin.install_symlink bin/"Xquartz" => "X" if OS.mac?
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <xcb/xcb.h>

      int main(void) {
        xcb_connection_t *connection = xcb_connect(NULL, NULL);
        int has_err = xcb_connection_has_error(connection);
        assert(has_err == 0);
        xcb_disconnect(connection);
        return 0;
      }
    EOS
    xcb = Formula["libxcb"]
    system ENV.cc, "./test.c", "-o", "test", "-I#{xcb.include}", "-L#{xcb.lib}", "-lxcb"

    fork do
      exec bin/"Xvfb", ":1"
    end
    system "cat", "/var/log/Xorg.0.log"
    ENV["DISPLAY"] = ":1"
    sleep 10
    system "./test"
  end
end
