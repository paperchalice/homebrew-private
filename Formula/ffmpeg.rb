class Ffmpeg < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-4.4.1.tar.xz"
  sha256 "eadbad9e9ab30b25f5520fbfde99fae4a92a1ae3c0257a8d68569a4651e30e02"
  license "GPL-2.0-or-later"
  head "https://github.com/FFmpeg/FFmpeg.git"

  depends_on "nasm"       => :build
  depends_on "pkgconf"    => :build
  depends_on "texinfo"    => :build

  depends_on "aom"
  depends_on "dav1d"
  depends_on "fdk-aac"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "frei0r"
  depends_on "game-music-emu"
  depends_on "jack"
  depends_on "lame"
  depends_on "libass"
  depends_on "libbluray"
  depends_on "libbs2b"
  depends_on "libcaca"
  depends_on "libgsm"
  depends_on "libmodplug"
  depends_on "librsvg"
  depends_on "libsoxr"
  depends_on "libssh"
  depends_on "libvidstab"
  depends_on "libvmaf"
  depends_on "libxml2"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "opencore-amr"
  depends_on "openh264"
  depends_on "openjpeg"
  depends_on "openssl@1.1"
  depends_on "opus"
  depends_on "rav1e"
  depends_on "rtmpdump"
  depends_on "rubberband"
  depends_on "sdl2"
  depends_on "snappy"
  depends_on "speex"
  depends_on "srt"
  depends_on "tesseract"
  depends_on "tesseract-lang"
  depends_on "theora"
  depends_on "two-lame"
  depends_on "webp"
  depends_on "x264"
  depends_on "x265"
  depends_on "xz"
  depends_on "xvid"
  depends_on "zeromq"
  depends_on "zimg"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --disable-htmlpages
      --enable-gpl
      --enable-nonfree
      --enable-chromaprint
      --enable-decklink
      --enable-libbluray
      --enable-libbs2b
      --enable-libaom
      --enable-libcaca
      --enable-libdav1d
      --enable-libfdk-aac
      --enable-libgme
      --enable-libgsm
      --enable-libjack
      --enable-indev=jack
      --enable-libmodplug
      --enable-libmp3lame
      --enable-libopencore-amrnb
      --enable-libopencore-amrwb
      --enable-libopenh264
      --enable-libopenjpeg
      --enable-libopus
      --enable-librav1e
      --enable-librsvg
      --enable-librtmp
      --enable-librubberband
      --enable-libsnappy
      --enable-libsoxr
      --enable-libspeex
      --enable-libsrt
      --enable-libssh
      --enable-libtesseract
      --enable-libtheora
      --enable-libtwolame
      --enable-libvmaf
      --enable-libvidstab
      --enable-libvorbis
      --enable-libwebp
      --enable-libxml2
      --enable-libxvid
      --enable-libvpx
      --enable-libx264
      --enable-libx265
      --enable-libfontconfig
      --enable-libfreetype
      --enable-libzimg
      --enable-libzmq
      --enable-openssl
      --enable-opencl
      --enable-frei0r
      --enable-videotoolbox
      --enable-version3
      --enable-libass
      --enable-demuxer=dash
    ]

    system "./configure", *args
    system "make", "install"

    # Build and install additional FFmpeg tools
    system "make", "alltools"
    bin.install Dir["tools/*"].select { |f| File.executable? f }
    mv bin/"python", pkgshare/"python", force: true
  end

  test do
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    assert_predicate mp4out, :exist?
  end
end
