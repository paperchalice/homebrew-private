class QtMultimediaFfmpeg < Formula
  desc "Qt plugin for ffmpeg"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.6/6.6.2/submodules/qtmultimedia-everywhere-src-6.6.2.tar.xz"
  sha256 "e2942599ba0ae106ab3e4f82d6633e8fc1943f8a35d91f99d1fca46d251804ec"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  livecheck do
    formula "qt"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "vulkan-headers" => [:build, :test]

  depends_on "ffmpeg"
  depends_on "qt"

  def install
    cmake_args = std_cmake_args + %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}
    ]

    ENV.permit_arch_flags
    system "cmake", *cmake_args, "-S", ".", "-B", "build"
    system "cmake", "--build", "build", "--target", "QFFmpegMediaPlugin"
    system "cmake", "-P", "build/src/plugins/multimedia/ffmpeg/cmake_install.cmake"
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
      find_package(Qt6 REQUIRED COMPONENTS Multimedia)
      add_executable(test
          main.cpp
      )
      target_link_libraries(test PRIVATE Qt6::Multimedia)
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QCoreApplication>
      #include <QTextStream>
      int main(int argc, char *argv[])
      {
        QCoreApplication::addLibraryPath("#{share}/qt/plugins");
        QCoreApplication a(argc, argv);
        QTextStream out(stdout);
        auto backends = QPlatformMediaIntegration::availableBackends();
        for(const auto &backend : backends)
          out << backend << '\n';
        return 0;
      }
    EOS
    system "cmake", testpath
    system "cmake", "--build", "."
    assert_match "ffmpeg", shell_output("./test")
  end
end
