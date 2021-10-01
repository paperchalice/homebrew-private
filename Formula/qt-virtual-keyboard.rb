class QtVirtualKeyboard < Formula
  desc "Qt Quick virtual keyboard"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.2/6.2.0/submodules/qtvirtualkeyboard-everywhere-src-6.2.0.tar.xz"
  sha256 "1055e7fe1dfaecbfd4b69f40ec1135fda1980e6e21adbe757a8a4affbfb9bcee"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtvirtualkeyboard.git", branch: "dev"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-virtual-keyboard-6.1.3"
    sha256 cellar: :any, big_sur: "3ec1fa52ea4d17d9263ef9e53d55d7069f777a1a3266a29917ef97a8c27a75b0"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "perl"       => :build
  depends_on "pkgconf"    => :build

  depends_on "hunspell"
  depends_on "libxcb"
  depends_on "qt-base"
  depends_on "qt-declarative"
  depends_on "qt-svg"

  def install
    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX) + %W[
      -D CMAKE_STAGING_PREFIX=#{prefix}

      -S .
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
