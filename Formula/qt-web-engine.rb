class QtWebEngine < Formula
  desc "Qt Quick web support"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.2/6.2.0/submodules/qtwebengine-everywhere-src-6.2.0.tar.xz"
  sha256 "c6e530a61bea2e7fbb50308a2b4e7fdb4f7c7b61a28797973270acffc020809d"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtwebengine.git", branch: "dev"

  depends_on "cmake"      => [:build, :test]
  depends_on "ninja"      => :build
  depends_on "perl"       => :build
  depends_on "pkgconf"    => :build
  depends_on "python"     => :build

  depends_on "node"
  depends_on "qt-base"
  depends_on "qt-declarative"
  depends_on "qt-location"
  depends_on "qt-tools"
  depends_on "qt-web-channel"

  uses_from_macos "bison" => :build
  uses_from_macos "flex"  => :build
  uses_from_macos "gperf" => :build

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  def install
    inreplace "cmake/Functions.cmake", 'clang_base_path="${clangBasePath}"', ""
    inreplace "src/CMakeLists.txt", "REALPATH", "ABSOLUTE"
    inreplace "src/gn/CMakeLists.txt", "REALPATH", "ABSOLUTE"

    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX) + %W[
      -D CMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
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
