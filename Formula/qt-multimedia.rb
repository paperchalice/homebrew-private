class QtMultimedia < Formula
  desc "Support for CAN and potentially other serial buses"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.3/6.3.0/submodules/qtmultimedia-everywhere-src-6.3.0.tar.xz"
  sha256 "d050247ff82974a8480c05ce602fd39e03d9e2d1b82bb78a3f42cf29b3a7fe3e"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtmultimedia.git", branch: "dev"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-multimedia-6.3.0"
    sha256 cellar: :any, monterey: "e82f334162afa86f57a893444d93da74a7f5c1c9d3fe9348803d4b59e28a05ea"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "perl"       => :build
  depends_on "pkgconf"    => :build

  depends_on "qt-base"
  depends_on "qt-declarative"
  depends_on "qt-shader-tools"

  def install
    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX) + %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}

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
