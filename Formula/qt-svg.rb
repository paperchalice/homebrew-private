class QtSvg < Formula
  desc "SVG support library for Qt"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.2/6.2.1/submodules/qtsvg-everywhere-src-6.2.1.tar.xz"
  sha256 "86e27e005c2421052ca90e619c8d13f1bd19c6bf1a7b84dd4e0f7855fc884fd7"
  license all_of: ["GPL-2.0-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtsvg.git", branch: "dev"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-svg-6.2.1"
    sha256 cellar: :any, big_sur: "56427c9060f8d466ec487f3e4f40a3c243f574f7b05367719ff40059693c5eb5"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "perl"       => :build
  depends_on "pkgconf"    => :build

  depends_on "qt-base"

  uses_from_macos "zlib"

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

      project(test VERSION 1.0.0 LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

      set(CMAKE_AUTOMOC ON)
      set(CMAKE_AUTORCC ON)
      set(CMAKE_AUTOUIC ON)

      find_package(Qt6 COMPONENTS Widgets REQUIRED)
      find_package(Qt6Svg COMPONENTS Widgets REQUIRED)

      add_executable(test
          main.cpp
      )

      target_link_libraries(test PRIVATE Qt6::Widgets Qt6::Svg)
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QCoreApplication>
      #include <QtSvg/QtSvg>
      #include <QDebug>

      int main(int argc, char *argv[])
      {
        QSvgGenerator generator;
        return 0;
      }
    EOS

    system "cmake", testpath
    system "cmake", "--build", "."
    system "./test"
  end
end
