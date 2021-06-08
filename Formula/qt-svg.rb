class QtSvg < Formula
  desc "SVG support library for Qt"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.1/submodules/qtsvg-everywhere-src-6.1.1.tar.xz"
  sha256 "e2f62385c940de76dea480a2615c9b11dd2bf0cec2cc778096c0bebfa1ef15ec"
  license all_of: ["GPL-2.0-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtsvg.git", branch: "dev"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-svg-6.1.1"
    sha256 cellar: :any, big_sur: "8722fb29012854cb665255b3522886baa0f92abf43b0bef7040467251a3ac33f"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "perl" => :build

  depends_on "qt-base"

  uses_from_macos "zlib"

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
      -D CMAKE_INSTALL_PREFIX=#{HOMEBREW_PREFIX}
      -D CMAKE_STAGING_PREFIX=#{prefix}

      .
    ]
    system "cmake", *args
    system "cmake", "--build", "."
    system "cmake", "--install", ".", "--strip"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink Dir["#{lib}/*.framework"]

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    Pathname.glob("#{lib}/*.framework/Headers") do |path|
      include.install_symlink path => path.parent.basename(".framework")
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
