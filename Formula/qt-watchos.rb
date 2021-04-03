class QtWatchos < Formula
  desc "Qt for watchOS"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.0/6.0.2/single/qt-everywhere-src-6.0.2.tar.xz"
  sha256 "67a076640647783b95a907d2231e4f34cec69be5ed338c1c1b33124cadf10bdf"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  revision 1

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-ios-6.0.2_1"
    sha256 big_sur: "60f23617add7f15215016a0053a5e9524869df69f0635ce5356ac4d4e3dbe84f"
  end

  keg_only "this is Qt SDK for TVOS"

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "qt" => :build

  depends_on :xcode

  uses_from_macos "perl"

  resource "qtimageformats" do
    url "https://download.qt.io/official_releases/additional_libraries/6.0/6.0.3/qtimageformats-everywhere-src-6.0.3.tar.xz"
    sha256 "327580b5a5b9a8d75e869c0eaa7ff34881bbde4e4ccc51d07a59e96054136837"
  end

  resource "qt3d" do
    url "https://download.qt.io/official_releases/additional_libraries/6.0/6.0.3/qt3d-everywhere-src-6.0.3.tar.xz"
    sha256 "470f95c559b68cc8faa982c1ca7ff83054d6802f7b2a0c1d960a155b92080cf9"
  end

  resource "qtnetworkauth" do
    url "https://download.qt.io/official_releases/additional_libraries/6.0/6.0.3/qtnetworkauth-everywhere-src-6.0.3.tar.xz"
    sha256 "124bf433e2c5418e900a5947d4ceb128ee179f514eddcea33924f0b695be64ed"
  end

  def install
    ENV.prepend "PATH", "/usr/bin"

    cmake_args = std_cmake_args.reject { |s| s["CMAKE_OSX_SYSROOT"]||s["CMAKE_FIND_FRAMEWORK"] } + %w[
      -DCMAKE_FIND_FRAMEWORK=FIRST
    ]

    system "./configure", "-xplatform", "macx-watchos-clang",
      "-qt-host-path", Formula["qt"].prefix.to_s, "--", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    rm bin/"qt-cmake-private-install.cmake"
    libexec.install bin/"target_qt.conf"
    libexec.install bin/"qmake"
    bin.write_exec_script libexec/"qmake"
  end

  test do
    ENV.delete "CPATH"
    (testpath/"test.pro").write <<~EOS
      QT       += core
      TARGET = test
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QCoreApplication>

      int main(int argc, char *argv[])
      {
        QCoreApplication a(argc, argv);
        return 0;
      }
    EOS

    system bin/"qmake", "test.pro"
    assert_predicate testpath/"test.xcodeproj", :exist?
  end
end
