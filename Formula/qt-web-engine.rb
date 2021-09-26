class QtWebEngine < Formula
  desc "Qt Quick web support"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/development_releases/qt/6.2/6.2.0-rc2/submodules/qtwebengine-everywhere-src-6.2.0-rc2.tar.xz"
  sha256 "d0088aea07c3b4fda06585f98fe8e7dfc13e8a1fcfd12388c6c1b4a4d97621d4"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtwebengine.git", branch: "dev"

  depends_on "cmake"      => [:build, :test]
  depends_on "ninja"      => :build
  depends_on "perl"       => :build
  depends_on "pkgconf"    => :build

  depends_on "node"
  depends_on "qt-base"
  depends_on "qt-declarative"
  depends_on "qt-location"
  depends_on "qt-tools"
  depends_on "qt-web-channel"
  depends_on "snappy"

  uses_from_macos "bison" => :build
  uses_from_macos "flex"  => :build
  uses_from_macos "gperf" => :build

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  def install
    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX) + %W[
      -D CMAKE_STAGING_PREFIX=#{prefix}

      -S .
      -G Ninja
    ]
    system "cmake", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", ".", "--strip"

    lib.glob("*.framework") do |f|
      frameworks.install_symlink f
      include.install_symlink f/"Headers" => f.stem
      lib.install_symlink f/f.stem => shared_library("lib#{f.stem}")
    end
  end

  test do
    system "echo"
  end
end
