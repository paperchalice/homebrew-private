class QtVirtualKeyboard < Formula
  desc "Qt Quick virtual keyboard"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.3/6.3.0/submodules/qtvirtualkeyboard-everywhere-src-6.3.0.tar.xz"
  sha256 "89aaf15acf5432af8f5cf4ec45cb32d87a3348906215dd56e81cb294eb276573"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtvirtualkeyboard.git", branch: "dev"

  livecheck do
    formula "qt"
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-virtual-keyboard-6.3.0"
    sha256 cellar: :any, monterey: "cc4a50d32512ad30e215096300f9394aabdab71ec45597dd9193d2789887445e"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "perl"       => :build
  depends_on "pkgconf"    => :build

  depends_on "hunspell"
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
