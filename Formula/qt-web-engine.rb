class QtWebEngine < Formula
  desc "Qt Quick web support"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.1/submodules/qtwebengine-everywhere-src-6.1.1.tar.xz"
  sha256 "246d1acdcd953819b09b1da22bd359335d145d8a3550d9e827dc1fd27b6bd3ff"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtwebengine.git", branch: "dev"

  depends_on "cmake"      => [:build, :test]
  depends_on "ninja"      => :build
  depends_on "perl"       => :build
  depends_on "pkg-config" => :build

  depends_on "ffmpeg"
  depends_on "icu4c"
  depends_on "libevent"
  depends_on "libvpx"
  depends_on "little-cms2"
  depends_on "minizip"
  depends_on "node"
  depends_on "opus"
  depends_on "protobuf"
  depends_on "qt-base"
  depends_on "qt-declarative"
  depends_on "qt-location"
  depends_on "qt-tools"
  depends_on "qt-web-channel"
  depends_on "re2"
  depends_on "snappy"

  uses_from_macos "bison" => :build
  uses_from_macos "flex"  => :build
  uses_from_macos "gperf" => :build

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  def install
    cmake_args = std_cmake_args(HOMEBREW_PREFIX) + %W[
      -D CMAKE_STAGING_PREFIX=#{prefix}

      -S .
    ]
    system "cmake", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", ".", "--strip"

    Pathname.glob(lib/"*.framework") do |f|
      frameworks.install_symlink f
      include.install_symlink f/"Headers" => f.basename
    end
  end

  test do
    system "echo"
  end
end
