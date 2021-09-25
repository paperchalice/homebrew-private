class QtWebSockets < Formula
  desc "Qt sockets support"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/development_releases/qt/6.2/6.2.0-rc2/submodules/qtwebsockets-everywhere-src-6.2.0-rc2.tar.xz"
  sha256 "94b49fedc45d1a1f12189518da8b00846c255f625cad6bebc95079499a65cce5"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtwebsockets.git", branch: "dev"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-web-sockets-6.2.0-rc2"
    sha256 cellar: :any, big_sur: "a3e79d10c888f196101edbd5a1e3cc70fcb8852f5b9491cb91d90cdefb887d9e"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "perl"       => :build
  depends_on "pkgconf"    => :build

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
