class QtQuick3d < Formula
  desc "New module and API for defining 3D content in Qt Quick"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.3/6.3.0/submodules/qtquick3d-everywhere-src-6.3.0.tar.xz"
  sha256 "0ad05bd1ee1f784b18220a2d2625ee8de91662c88fdc7b798662953d86eb327e"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtquick3d.git", branch: "dev"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-quick3d-6.2.0"
    sha256 cellar: :any, big_sur: "027887dd2dc28ed112e339c23055bb6f377792e6f6c7554503d26c880df3f65e"
  end

  depends_on "cmake"   => [:build, :test]
  depends_on "perl"    => :build
  depends_on "pkgconf" => :build

  depends_on "assimp"
  depends_on "qt-base"
  depends_on "qt-declarative"
  depends_on "qt-quick-timeline"
  depends_on "qt-shader-tools"

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
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION #{Formula["cmake"].version})

      project(test_project VERSION 1.0.0 LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

      set(CMAKE_AUTOMOC ON)
      set(CMAKE_AUTORCC ON)
      set(CMAKE_AUTOUIC ON)

      find_package(Qt6 COMPONENTS Widgets REQUIRED)
      find_package(Qt6Quick3D COMPONENTS Widgets REQUIRED)

      add_executable(test
          main.cpp
      )

      target_link_libraries(test PRIVATE Qt6::Widgets Qt6::Quick3D)
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QCoreApplication>
      #include <QtQuick3D>
      #include <QDebug>

      int main(int argc, char *argv[])
      {
        return 0;
      }
    EOS

    system "cmake", testpath
    system "cmake", "--build", "."
    system "./test"
  end
end
