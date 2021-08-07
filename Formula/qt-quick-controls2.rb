class QtQuickControls2 < Formula
  desc "Next generation user interface controls based on Qt Quick"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.2/submodules/qtquickcontrols2-everywhere-src-6.1.2.tar.xz"
  sha256 "808f30c3308654ff3c1be6c8e304a59060c5ea7ff6afe7b21fb55be7d5442f28"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtquickcontrols2.git", branch: "dev"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-quick-controls2-6.1.2"
    sha256 cellar: :any, big_sur: "5ceea6cf9cea3318b740e5c9da30b598ab1c18391696efb17cdb3cc4def6b096"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "perl"       => :build
  depends_on "pkg-config" => :build

  depends_on "qt-declarative"
  depends_on "qt-imageformats"

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
      -D CMAKE_INSTALL_PREFIX=#{HOMEBREW_PREFIX}
      -D CMAKE_STAGING_PREFIX=#{prefix}
    ]
    system "cmake", ".", *args
    system "cmake", "--build", "."
    system "cmake", "--install", ".", "--strip"

    Pathname.glob(lib/"*.framework") do |f|
      frameworks.install_symlink f
      include.install_symlink f/"Headers" => f.basename
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

      find_package(Qt6 COMPONENTS Widgets REQUIRED)
      find_package(Qt6QuickControls2 COMPONENTS Widgets REQUIRED)

      add_executable(test
          main.cpp
      )

      target_link_libraries(test PRIVATE Qt6::Widgets Qt6::QuickControls2)
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QCoreApplication>
      #include <QtQuickControls2/QtQuickControls2>
      #include <QDebug>

      int main(int argc, char *argv[])
      {
        return 0;
      }
    EOS

    system "cmake", "."
    system "cmake", "--build", "."
    system "./test"
  end
end
