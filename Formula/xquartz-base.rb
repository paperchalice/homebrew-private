class XquartzBase < Formula
  desc "XQuartz base directory"
  homepage "https://www.xquartz.org/"
  url "https://github.com/XQuartz/XQuartz/archive/refs/tags/XQuartz-2.8.2.tar.gz"
  sha256 "050c538cf2ed39f49a366c7424c7b22781c9f7ebe02aa697f12e314913041000"
  license "APSL-2.0"

  def install
    system "echo", std_cmake_args
    system "false"
    prefix.install Dir["base/opt/X11/*"]
    (share/"fonts/X11").install share/"fonts/TTF"

    (prefix.glob "**/*").each do |f|
      inreplace f, "/opt/X11", HOMEBREW_PREFIX, false if f.file?
    end

    inreplace bin/"font_cache" do |s|
      # provided by formula `procmail`
      s.gsub! %r{/usr/bin(?=/lockfile)}, HOMEBREW_PREFIX
      # set `X11FONTDIR`, align with formula `font-util`
      s.gsub! "share/fonts", "share/fonts/X11"
    end

    # align with formula `font-util`
    font_paths = %w[misc TTF OTF Type1 75dpi 100dpi].map do |f|
      p = HOMEBREW_PREFIX/"share/fonts/X11"/f
      <<~EOS
        # ident
            [ -e #{p}/fonts.dir ] && fontpath="$fontpath,#{p}#{",#{p}/:unscaled" if /\d+dpi/.match? p}"\n
      EOS
      %Q(    [ -e #{p}/fonts.dir ] && fontpath="$fontpath,#{p}#{",#{p}/:unscaled" if /\d+dpi/.match? p}"\n)
    end
    lines = File.readlines prefix/"etc/X11/xinit/xinitrc.d/10-fontdir.sh"
    lines[1] = %Q(    fontpath="built-ins"\n) + font_paths.join
    File.write(prefix/"etc/X11/xinit/xinitrc.d/10-fontdir.sh", lines.join)

    # /System/Library/Fonts is protected by SIP
    mkdir_p share/"system_fonts"
    system Formula["lndir"].bin/"lndir", "/System/Library/Fonts", share/"system_fonts"
    system Formula["mkfontscale"].bin/"mkfontdir", share/"system_fonts"
  end

  test do
    system bin/"font_cache"
  end
end
