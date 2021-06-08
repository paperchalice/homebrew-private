class Qt3d < Formula
  desc "3D Lib"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.1/submodules/qt3d-everywhere-src-6.1.1.tar.xz"
  sha256 "66e25fcf0bd965374f9814ef8fb960ff7c0414ec9480dcdc57caad17f23ede08"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qt3d.git", branch: "dev"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-3d-6.1.0"
    sha256 cellar: :any, big_sur: "eb8a10326ae1cb9924aa52e6145599c0b959246799e2cd250425d683dab7c3aa"
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
