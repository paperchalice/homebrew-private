class QtImageformats < Formula
  desc "Qt additional image formats support"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/additional_libraries/6.0/6.0.2/qtimageformats-everywhere-src-6.0.2.tar.xz"
  sha256 "b0379ba6bbefbc48ed3ef8a1d8812531bd671362f74e0cffa6adf67bb1139206"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  depends_on "jasper"
  depends_on "libtiff"
  depends_on "qt-base"
  depends_on "webp"

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
      -DCMAKE_INSTALL_PREFIX=#{HOMEBREW_PREFIX}
      -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
      -DCMAKE_STAGING_PREFIX=#{prefix}
    ]
    system "cmake", "-G", "Ninja", ".", *args
    system "ninja"
    system "ninja", "install"
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

      find_package(Qt6 COMPONENTS Core Gui REQUIRED)

      add_executable(test
          main.cpp
      )

      target_link_libraries(test PRIVATE Qt6::Core Qt6::Gui)
    EOS

    (testpath/"test.pro").write <<~EOS
      QT       += core gui
      TARGET = test
      CONFIG   += console debug
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QCoreApplication>
      #include <QImageReader>
      #include <QDebug>

      int main(int argc, char *argv[])
      {
        const auto &list = QImageReader::supportedImageFormats();
        for(const char* fmt:{"bmp", "cur", "gif", "heic", "heif",
          "icns", "ico", "jp2", "jpeg", "jpg", "pbm", "pgm", "png",
          "ppm", "svg", "svgz", "tga", "tif", "tiff", "wbmp", "webp",
          "xbm", "xpm"}) {
          Q_ASSERT(list.contains(fmt));
        }
        return 0;
      }
    EOS

    system "cmake", "."
    system "make"
    system "./test"

    ENV.delete "CPATH"
    system "qmake", "./test.pro"
    system "make"
    system "./test"
  end
end
