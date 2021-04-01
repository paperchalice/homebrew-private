class Qt3d < Formula
  desc "3D Lib"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/additional_libraries/6.0/6.0.3/qt3d-everywhere-src-6.0.3.tar.xz"
  sha256 "470f95c559b68cc8faa982c1ca7ff83054d6802f7b2a0c1d960a155b92080cf9"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qt3d.git", branch: "dev"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-3d-6.0.2"
    sha256 cellar: :any, big_sur: "30eda0f7a718090aeb2cc1f9c12ecb8451220da39150f7f2d3fb35413b20b851"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on xcode: :test

  depends_on "qt-quick3d"

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
      -DCMAKE_INSTALL_PREFIX=#{HOMEBREW_PREFIX}
      -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
      -DCMAKE_STAGING_PREFIX=#{prefix}

      -DFEATURE_qt3d_system_assimp=ON
      -DTEST_assimp=ON
    ]
    system "cmake", "-G", "Ninja", ".", *args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    frameworks.install_symlink Dir["#{lib}/*.framework"]

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

      find_package(Qt6 COMPONENTS Core 3DCore REQUIRED)

      add_executable(test
          main.cpp
      )

      target_link_libraries(test PRIVATE Qt6::Core Qt6::3DCore)
    EOS

    (testpath/"test.pro").write <<~EOS
      QT       += core 3dcore
      QT       -= gui
      TARGET = test
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QCoreApplication>
      #include <Qt3DCore>
      #include <QDebug>

      int main(int argc, char *argv[])
      {
        auto *root = new Qt3DCore::QEntity();
        return 0;
      }
    EOS

    system "cmake", "."
    system "cmake", "--build", "."

    system "qmake", "./test.pro"
    system "make"
  end
end
