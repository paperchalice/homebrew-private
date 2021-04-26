class QtNetworkauth < Formula
  desc "Qt network authentication"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/additional_libraries/6.0/6.0.3/qtnetworkauth-everywhere-src-6.0.3.tar.xz"
  sha256 "124bf433e2c5418e900a5947d4ceb128ee179f514eddcea33924f0b695be64ed"
  license "GPL-3.0-only"
  head "https://code.qt.io/qt/qtnetworkauth.git", branch: "dev"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-networkauth-6.0.3"
    sha256 cellar: :any, big_sur: "d5db4bf7f5fc8698d880a0327a99e5368df34380c291a3771bdc4da743ea3a42"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "perl" => :build

  depends_on "qt-base"

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] || s["CMAKE_BUILD_TYPE"] } + %W[
      -DCMAKE_BUILD_TYPE=MinSizeRel
      -DCMAKE_INSTALL_PREFIX=#{HOMEBREW_PREFIX}
      -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
      -DCMAKE_STAGING_PREFIX=#{prefix}
    ]
    system "cmake", ".", *args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

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

      find_package(Qt6 COMPONENTS Core Network NetworkAuth REQUIRED)

      add_executable(test
          main.cpp
      )

      target_link_libraries(test PRIVATE Qt6::Core Qt6::Network Qt6::NetworkAuth)
    EOS

    (testpath/"test.pro").write <<~EOS
      QT       += core network networkauth
      QT       -= gui
      TARGET = test
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QCoreApplication>
      #include <QtNetworkAuth>
      #include <QDebug>

      int main(int argc, char *argv[])
      {
        auto p = new QOAuthHttpServerReplyHandler();
        return 0;
      }
    EOS

    system "cmake", "."
    system "cmake", "--build", "."

    system "qmake", "test.pro"
    system "make"
  end
end
