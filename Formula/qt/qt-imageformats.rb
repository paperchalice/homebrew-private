class QtImageformats < Formula
  desc "Qt additional image formats support"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.3/6.3.0/submodules/qtimageformats-everywhere-src-6.3.0.tar.xz"
  sha256 "025d0d17ed75b42a7eb6b523731ab8f17025421a8810cade25caffe05d93abef"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtimageformats.git", branch: "dev"

  livecheck do
    formula "qt"
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-imageformats-6.3.0"
    sha256 cellar: :any, monterey: "9ac69ff59d3c8911c005308647fca72057599dfe5c2b8e363fa4e338d53ca404"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "perl"       => :build
  depends_on "pkgconf"    => :build

  depends_on "jasper"
  depends_on "libmng"
  depends_on "libtiff"
  depends_on "qt-base"
  depends_on "webp"

  uses_from_macos "zlib"

  def install
    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX) + %W[
      -D CMAKE_STAGING_PREFIX=#{prefix}

      -S .
    ]
    system "cmake", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", ".", "--strip"
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

    (testpath/"main.cpp").write <<~EOS
      #include <QCoreApplication>
      #include <QImageReader>
      #include <QDebug>

      int main(int argc, char *argv[])
      {
        const auto &list = QImageReader::supportedImageFormats();
        qDebug() << list;
        for(const char* fmt:{"bmp", "cur", "gif", "heic", "heif",
          "icns", "ico", "jp2", "jpeg", "jpg", "pbm", "pgm", "png",
          "ppm", "tga", "tif", "tiff", "wbmp", "webp", "xbm", "xpm"}) {
          Q_ASSERT(list.contains(fmt));
        }
        return 0;
      }
    EOS

    system "cmake", ".", "-DCMAKE_BUILD_TYPE=Debug"
    system "cmake", "--build", "."
    system "./test"
  end
end
