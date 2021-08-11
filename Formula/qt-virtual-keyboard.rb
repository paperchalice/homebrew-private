class QtVirtualKeyboard < Formula
  desc "Qt Quick virtual keyboard"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.2/submodules/qtvirtualkeyboard-everywhere-src-6.1.2.tar.xz"
  sha256 "25cbdf595f5c82d8bc8aea4c95c5adfc08555d540451afac4a1bc0194db3eae0"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtvirtualkeyboard.git", branch: "dev"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-virtual-keyboard-6.1.2"
    sha256 cellar: :any, big_sur: "21cdacca833a3ad45c95b8ca1a896ef3a5ab66a4efc6c7cd93916be1d5a51f21"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "perl"       => :build
  depends_on "pkg-config" => :build

  depends_on "hunspell"
  depends_on "libxcb"
  depends_on "qt-base"
  depends_on "qt-declarative"
  depends_on "qt-svg"

  def install
    cmake_args = std_cmake_args(HOMEBREW_PREFIX) + %W[
      -D CMAKE_STAGING_PREFIX=#{prefix}

      -S .
    ]
    system "cmake", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", ".", "--strip"

    Dir[lib/"*.framework"] do |f|
      frameworks.install_symlink f
      include.install_symlink f/"Headers" => f.basename
    end
  end

  test do
    system "echo"
  end
end
