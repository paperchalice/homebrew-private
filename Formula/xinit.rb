class Xinit < Formula
  desc "Start the X Window System server"
  homepage "https://www.x.org/"
  url "https://www.x.org/releases/individual/app/xinit-1.4.1.tar.bz2"
  sha256 "de9b8f617b68a70f6caf87da01fcf0ebd2b75690cdcba9c921d0ef54fa54abb9"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xinit-1.4.1"
    rebuild 1
    sha256 monterey: "b8969ebfbd619fe46d61fa27526d111570aedbd334a96b3ec402a993c2531e1f"
  end

  depends_on "pkgconf" => :build
  depends_on "tradcpp" => :build

  depends_on "libx11"
  depends_on "mkfontscale"
  depends_on "xauth"
  depends_on "xorg-server"
  depends_on "xrdb"
  depends_on "xset"

  resource "font_cache" do
    url "https://raw.githubusercontent.com/XQuartz/XQuartz/master/base/opt/X11/bin/font_cache"
    sha256 "8f27cf55e5053686350fce6ea1078e314bd5b2d752e9da1b9051541e643e79d6"
  end

  def install
    configure_args = std_configure_args + %W[
      RAWCPP=tradcpp
      --disable-silent-rules
      --with-bundle-id-prefix=sh.brew
      --with-launchagents-dir=#{prefix}
      --with-launchdaemons-dir=#{prefix}
    ]

    system "./configure", *configure_args
    system "make"
    system "make", "install"

    bin.install_symlink Formula["xorg-server"].bin/"Xquartz" => "X"
    bin.install resource("font_cache")
    inreplace bin/"font_cache", "/opt/X11", HOMEBREW_PREFIX
    inreplace bin/"startx", prefix, HOMEBREW_PREFIX
    inreplace prefix/"etc/X11/xinit/xinitrc", prefix, HOMEBREW_PREFIX
    (prefix/"etc/X11/xinit/xinitrc.d/10-fontdir.sh").write <<~SH
      #!/bin/sh
      if [ -x #{HOMEBREW_PREFIX}/bin/xset ] ; then
        fontpath="#{HOMEBREW_PREFIX}/share/fonts/misc/,#{HOMEBREW_PREFIX}/share/fonts/TTF/,#{HOMEBREW_PREFIX}/share/fonts/OTF,#{HOMEBREW_PREFIX}/share/fonts/Type1/,#{HOMEBREW_PREFIX}/share/fonts/75dpi/:unscaled,#{HOMEBREW_PREFIX}/share/fonts/100dpi/:unscaled,#{HOMEBREW_PREFIX}/share/fonts/75dpi/,#{HOMEBREW_PREFIX}/share/fonts/100dpi/"

        [ -e #{HOMEBREW_PREFIX}/share/fonts/libwmf/fonts.dir ] && fontpath="$fontpath,#{HOMEBREW_PREFIX}/share/fonts/libwmf"
        [ -e #{HOMEBREW_PREFIX}/share/fonts/urw-fonts/fonts.dir ] && fontpath="$fontpath,#{HOMEBREW_PREFIX}/share/fonts/urw-fonts"
        [ -e "$HOME"/.fonts/fonts.dir ] && fontpath="$fontpath,$HOME/.fonts"
        [ -e "$HOME"/Library/Fonts/fonts.dir ] && fontpath="$fontpath,$HOME/Library/Fonts"
        [ -e /Library/Fonts/fonts.dir ] && fontpath="$fontpath,/Library/Fonts"
        [ -e /System/Library/Fonts/fonts.dir ] && fontpath="$fontpath,/System/Library/Fonts"

        #{HOMEBREW_PREFIX}/bin/xset fp= "$fontpath"
        unset fontpath
      fi
    SH
    (prefix/"etc/X11/xinit/xinitrc.d/98-user.sh").write <<~SH
      #!/bin/sh
      if [ -d "${HOME}/.xinitrc.d" ] ; then
        for f in "${HOME}"/.xinitrc.d/*.sh ; do
                [ -x "$f" ] && . "$f"
        done
        unset f
      fi
    SH
    (prefix/"etc/X11/xinit/xinitrc.d/99-quartz-wm.sh").write <<~SH
      #!/bin/sh
      [ -n "${USERWM}" -a -x "${USERWM}" ] && exec "${USERWM}" &
      [ -x #{HOMEBREW_PREFIX}/bin/quartz-wm ] && exec #{HOMEBREW_PREFIX}/bin/quartz-wm &
    SH
    %w[10-fontdir 98-user 99-quartz-wm].each do |x|
      chmod "+x", prefix/"etc/X11/xinit/xinitrc.d/#{x}.sh"
    end
  end

  def plist_name
    "sh.brew.startx"
  end

  test do
    system "echo"
  end
end
