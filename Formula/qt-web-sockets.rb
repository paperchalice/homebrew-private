class QtWebSockets < Formula
  desc "Qt sockets support"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.4/6.4.0/submodules/qtwebsockets-everywhere-src-6.4.0.tar.xz"
  sha256 "ff3c6629cd6537266123c441709acdd67f231ff2a07216fc848448255bec9bca"
  license all_of: [
    "BSD-3-Clause",
    "GFDL-1.3-no-invariants-only",
    "GPL-2.0-only",
    "LGPL-3.0-only",
    "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" },
  ]
  head "https://code.qt.io/qt/qtwebsockets.git", branch: "dev"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-web-sockets-6.3.0"
    sha256 cellar: :any, monterey: "362abec088e2b2e4c7a7b8c89ba8d5d2145c534f6587a2f1c6007a2423ca797d"
  end

  depends_on "cmake"   => [:build, :test]
  depends_on "perl"    => :build
  depends_on "pkgconf" => :build

  depends_on "qt-base"
  depends_on "qt-declarative"

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
