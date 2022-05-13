class Xinit < Formula
  desc "Start the X Window System server"
  homepage "https://www.x.org/"
  url "https://www.x.org/releases/individual/app/xinit-1.4.1.tar.bz2"
  sha256 "de9b8f617b68a70f6caf87da01fcf0ebd2b75690cdcba9c921d0ef54fa54abb9"
  license "MIT"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/xinit-1.4.1"
    rebuild 3
    sha256 monterey: "dd0673e81dd304308d7fb6a491a2dbe62da74cd368a6a2215970f24a615630ad"
  end

  depends_on "lndir"      => :build
  depends_on "pkg-config" => :build
  depends_on "tradcpp"    => :build

  depends_on "libx11"
  depends_on "mkfontscale"
  depends_on "xauth"
  depends_on "xorg-server"
  depends_on "xrdb"
  depends_on "xterm"

  resource "font_cache" do
    url "https://raw.githubusercontent.com/XQuartz/XQuartz/XQuartz-2.8.1/base/opt/X11/bin/font_cache"
    sha256 "8f27cf55e5053686350fce6ea1078e314bd5b2d752e9da1b9051541e643e79d6"
  end

  resource "98-user.sh" do
    url "https://raw.githubusercontent.com/XQuartz/XQuartz/XQuartz-2.8.1/base/opt/X11/etc/X11/xinit/xinitrc.d/98-user.sh"
    sha256 "b417aea949931b7c03133535c3b5146b9403b8c3482a1c1d0a5dc01c07876c84"
  end

  def install
    configure_args = std_configure_args + %W[
      --with-bundle-id-prefix=homebrew.mxcl
      --with-launchagents-dir=#{prefix}
      --with-launchdaemons-dir=#{prefix}
      --with-xserver=#{Formula["xorg-server"].opt_bin}/X
    ]

    system "./configure", *configure_args
    system "make", "RAWCPP=tradcpp"
    system "make", "install"

    # generate fonts dir
    mkdir share/"system_fonts"
    system "lndir", "/System/Library/Fonts", share/"system_fonts"

    # install scripts
    if OS.mac?
      bin.install resource("font_cache") if OS.mac?
      inreplace bin/"font_cache" do |s|
        s.gsub! "/opt/X11", HOMEBREW_PREFIX
        s.gsub! "/usr/bin/lockfile", Formula["procmail"].opt_bin/"lockfile"
      end
    end
    (prefix/"etc/X11/xinit/xinitrc.d").install resource("98-user.sh")
    inreplace bin/"startx", prefix, HOMEBREW_PREFIX
    inreplace prefix/"etc/X11/xinit/xinitrc" do |s|
      s.gsub! prefix, opt_prefix
      s.gsub! "twm", Formula["quartz-wm"].opt_bin/"quartz-wm"
      s.gsub! "xclock", "# xclock"
      s.gsub!(/^xterm/, "# xterm")
    end
    share_fonts= HOMEBREW_PREFIX/"share/fonts"
    dpis = %w[75dpi 100dpi]
    fontdirs = %w[misc TTF OTF Type1 75dpi 100dpi libwmf urw-fonts].map do |d|
      <<~EOS.squish
        [ -e #{share_fonts}/#{d}/fonts.dir ] &&
          fontpath="$fontpath,#{share_fonts}/#{d}#{",#{share_fonts}/#{d}/:unscaled" if dpis.include? d}"
      EOS
    end + %w["$HOME"/.fonts "$HOME"/Library/Fonts /Library/Fonts /System/Library/Fonts].map do |d|
      <<~EOS.squish
        [ -e #{d}/fonts.dir ] && fontpath="$fontpath,#{d}"
      EOS
    end
    (prefix/"etc/X11/xinit/xinitrc.d/10-fontdir.sh").write <<~SH
      #!/bin/sh
      if [ -x #{HOMEBREW_PREFIX}/bin/xset ] ; then
        fontpath="built-ins"
        #{fontdirs.join "\n  "}

        #{HOMEBREW_PREFIX}/bin/xset fp= "$fontpath"
        unset fontpath
      fi
    SH
    %w[10-fontdir 98-user].each do |x|
      chmod "+x", prefix/"etc/X11/xinit/xinitrc.d/#{x}.sh"
    end
  end

  def caveats
    <<~EOS
      enable the homebrew.mxcl.privileged_startx:
      `sudo chown root #{opt_prefix}/homebrew.mxcl.privileged_startx.plist`
      `sudo launchctl bootstrap system #{opt_prefix}homebrew.mxcl.privileged_startx.plist`
    EOS
  end

  def plist_name
    "homebrew.mxcl.startx"
  end

  test do
    system "echo"
  end
end
