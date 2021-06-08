class QtDatavis3d < Formula
  desc "Qt 3D data visualization framework"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.1/submodules/qtdatavis3d-everywhere-src-6.1.1.tar.xz"
  sha256 "545a4d7c51f3b0be1446b0f8cd1eebba854018e635dba99b1765daed50322712"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtdatavis3d.git", branch: "dev"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-datavis3d-6.1.1"
    sha256 cellar: :any, big_sur: "f97c07a7ce1e00432f810449cb4d3a7283f620a6c77074dabad6908e53a32add"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "perl" => :build

  depends_on "qt-base"
  depends_on "qt-declarative"

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
      -DCMAKE_INSTALL_PREFIX=#{HOMEBREW_PREFIX}
      -DCMAKE_STAGING_PREFIX=#{prefix}
    ]
    system "cmake", ".", *args
    system "cmake", "--build", "."
    system "cmake", "--install", ".", "--strip"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink Dir[lib/"*.framework"]

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
