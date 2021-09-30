class QtScxml < Formula
  desc "State Machine Notation compiler and related tools"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.2/6.2.0/submodules/qtscxml-everywhere-src-6.2.0.tar.xz"
  sha256 "90d4af011a17f04a003cbd453c7e0720787e6cdacb8dfce7167179c2cd7dc839"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtscxml.git", branch: "dev"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-scxml-6.2.0"
    sha256 cellar: :any, big_sur: "1dce00f4d36e8a25c8d15ecfe3fcbb35926e1a947a6c7928a21bbb2cdf93037d"
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
