class QtQuick3dPhysics < Formula
  desc "High-level API for physics simulation"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.4/6.4.0/submodules/qtquick3dphysics-everywhere-src-6.4.0.tar.xz"
  sha256 "dc59443434d1255fb0cfc50c28ccf391e50745d67014b4aa787cd7571c28fd07"
  license all_of: [
    "BSD-3-Clause",
    "GFDL-1.3-no-invariants-only",
    "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" },
  ]

  livecheck do
    formula "qt"
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-quick3d-physics-6.4.0"
    sha256 cellar: :any, monterey: "df191a172a7aa09ba2a2d725df0784b6d5e1d9179086f2d7344bdc3fa3ea0dbe"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "perl"    => :build
  depends_on "pkgconf" => :build

  depends_on "qt-quick3d"
  depends_on "qt-shader-tools"

  def install
    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX) + %W[
      -D CMAKE_STAGING_PREFIX=#{prefix}

      -S .
    ]
    system "cmake", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

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
