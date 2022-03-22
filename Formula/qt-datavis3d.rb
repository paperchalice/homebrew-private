class QtDatavis3d < Formula
  desc "Qt 3D data visualization framework"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.2/6.2.1/submodules/qtdatavis3d-everywhere-src-6.2.1.tar.xz"
  sha256 "bfcf311df531498705786d0a689ae50a26169ce7db5da10e97ab579815bfb009"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtdatavis3d.git", branch: "dev"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-datavis3d-6.2.1"
    sha256 cellar: :any, big_sur: "678377ddcbc8f5420d2a736b419b83f6afa5406150fa5e2e1958fa14b95135b2"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "perl"       => :build
  depends_on "pkgconf"    => :build

  depends_on "qt-base"
  depends_on "qt-declarative"

  def install
    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX) + %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}

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

      find_package(Qt6 COMPONENTS Core DataVisualization Gui Widgets)

      add_executable(test
          main.cpp
      )

      target_link_libraries(test PRIVATE Qt6::Widgets Qt::DataVisualization)
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QtWidgets/QApplication>
      #include <QtDataVisualization/Q3DSurface>
      int main(int argc, char *argv[]) {
        QApplication a(argc, argv);

        return 0;
      }
    EOS

    system "cmake", "."
    system "cmake", "--build", "."
  end
end
