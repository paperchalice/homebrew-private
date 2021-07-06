class Qt3d < Formula
  desc "3D Lib"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.2/submodules/qt3d-everywhere-src-6.1.2.tar.xz"
  sha256 "632e6dfa3af4e9ef6d8c54843e5db62b07b3d8a3435d2687e4dd256efd8f0d2d"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qt3d.git", branch: "dev"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-3d-6.1.1"
    sha256 cellar: :any, big_sur: "3c7e41797bb057ad7d503a499299a10a8fbc50a09318cfc78eab0f686ca4d695"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "perl" => :build

  depends_on "assimp"
  depends_on "qt-base"
  depends_on "qt-declarative"
  depends_on "qt-shader-tools"

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
      -D CMAKE_INSTALL_PREFIX=#{HOMEBREW_PREFIX}
      -D CMAKE_STAGING_PREFIX=#{prefix}

      -D FEATURE_qt3d_simd_avx2=ON
      -D FEATURE_qt3d_system_assimp=ON
      -D TEST_assimp=ON
    ]
    system "cmake", ".", *args
    system "cmake", "--build", "."
    system "cmake", "--install", ".", "--strip"

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
  end
end
