class QtLottie < Formula
  desc "Describing 2D vector graphics animations"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.1/submodules/qtlottie-everywhere-src-6.1.1.tar.xz"
  sha256 "df8ee26ea3aa4524f82703f602449d990724ca232cb98498746e8f49e23037ed"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtlottie.git", branch: "dev"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-lottie-6.1.1"
    sha256 cellar: :any, big_sur: "bdceb14cb38982f2c833b734a4f02eda04146b2288e4584db459e5e8eac26932"
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

      find_package(Qt6 COMPONENTS Core Widgets)

      add_executable(test
          main.cpp
      )

      target_link_libraries(test PRIVATE Qt6::Widgets)
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QtWidgets/QApplication>
      int main(int argc, char *argv[]) {
        QApplication a(argc, argv);

        return 0;
      }
    EOS
  end
end
