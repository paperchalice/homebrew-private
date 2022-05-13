class Xinit < Formula
  desc "Start the X Window System server"
  homepage "https://www.x.org/"
  url "https://www.x.org/releases/individual/app/xinit-1.4.1.tar.bz2"
  sha256 "de9b8f617b68a70f6caf87da01fcf0ebd2b75690cdcba9c921d0ef54fa54abb9"
  license all_of: ["MIT", "APSL-2.0"]

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

    inreplace bin/"startx", prefix, HOMEBREW_PREFIX
    inreplace bin/"startx", HOMEBREW_PREFIX/"libexec", opt_libexec
    inreplace prefix/"etc/X11/xinit/xinitrc", prefix, opt_prefix
    # install scripts
    if OS.mac?
      bin.install resource("font_cache") if OS.mac?
      inreplace bin/"font_cache" do |s|
        s.gsub! "/opt/X11", HOMEBREW_PREFIX
        s.gsub! "/usr/bin/lockfile", HOMEBREW_PREFIX/"lockfile"
      end

      (prefix/"etc/X11/xinit/xinitrc.d").install resource("98-user.sh")
      chmod "+x", prefix/"etc/X11/xinit/xinitrc.d/98-user.sh"

      font_paths = %w[misc TTF OTF Type1 75dpi 100dpi system_fonts].map do |f|
        HOMEBREW_PREFIX/"share/fonts/X11"/f
      end
      font_paths += %w[$HOME/.fonts $HOME/Library/Fonts /Library/Fonts]
      font_paths.map! do |p|
        %Q([ -e #{p}/fonts.dir ] && fontpath="$fontpath,#{p}#{",#{p}/:unscaled" if /\d+dpi/.match? p}")
      end
      (prefix/"etc/X11/xinit/xinitrc.d/10-fontdir.sh").write <<~SH
        #!/bin/sh
        if [ -x #{HOMEBREW_PREFIX}/xset ] ; then
          fontpath="built-ins"
          #{font_paths.join "\n  "}

          #{HOMEBREW_PREFIX}/xset fp= "$fontpath"
          unset fontpath
        fi
      SH
      chmod "+x", prefix/"etc/X11/xinit/xinitrc.d/10-fontdir.sh"
    end
  end

  def post_install
    if OS.mac?
      # generate fonts dir
      mkdir_p share/"X11/system_fonts"
      system "lndir", "/System/Library/Fonts", share/"X11/system_fonts"
      system Formula["mkfontscale"].opt_bin/"mkfontdir", share/"X11/system_fonts"
    end
  end

  def plist_name
    "homebrew.mxcl.startx"
  end

  test do
    system "echo"
  end
end
