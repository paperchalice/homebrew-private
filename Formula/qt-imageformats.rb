class QtImageformats < Formula
  desc "Qt additional image formats support"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.1/submodules/qtimageformats-everywhere-src-6.1.1.tar.xz"
  sha256 "d7ee9d96ed6958241acde2b5d505f89d7dcfd710d0944b100ac6de203b0e107d"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtimageformats.git", branch: "dev"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-imageformats-6.1.0"
    sha256 cellar: :any, big_sur: "e72c958ce186c910a30a926b7035ed6bb09ab7142241b195d44bd484d41bf8aa"
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
      -D CMAKE_STAGING_PREFIX=#{prefix}
    ]
    system "cmake", ".", *args
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
