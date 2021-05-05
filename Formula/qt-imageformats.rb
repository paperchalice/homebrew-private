class QtImageformats < Formula
  desc "Qt additional image formats support"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/additional_libraries/6.0/6.0.4/qtimageformats-everywhere-src-6.0.4.tar.xz"
  sha256 "c284b2eb413a7cf62ba7168c693b7498539fc41dfd9f29dd3ce5c5b46d8d1073"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtimageformats.git", branch: "dev"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-imageformats-6.0.3"
    sha256 cellar: :any, big_sur: "c1731c57dcadd42d6b8a1d4fb0690de98485c9d2b81512e47f0fafc2f242a962"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "perl" => :build

  depends_on "jasper"
  depends_on "libtiff"
  depends_on "qt-base"
  depends_on "webp"

  uses_from_macos "zlib"

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
      -D CMAKE_INSTALL_PREFIX=#{HOMEBREW_PREFIX}
      -D CMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
      -D CMAKE_STAGING_PREFIX=#{prefix}
    ]
    system "cmake", ".", *args
    system "cmake", "--build", "."
    system "cmake", "--install", "."
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
