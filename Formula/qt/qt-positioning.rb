class QtPositioning < Formula
  desc "Positioning information via QML and C++ interfaces"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.5/6.5.0/submodules/qtpositioning-everywhere-src-6.5.0.tar.xz"
  sha256 "0da7121ebfd9d2ba985ab1f2c8a3af70027c35732177ec0fc72ff7e82835c886"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtpositioning.git", branch: "dev"

  livecheck do
    formula "qt"
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-positioning-6.5.0"
    sha256 cellar: :any, monterey: "ed50dc11474df3fed2fe5c20d896ea069e275d0940104a3360534949ef2e0861"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkgconf" => :build

  depends_on "qt-base"
  depends_on "qt-declarative"
  depends_on "qt-serial-port"

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
