class QtTvos < Formula
  desc "Qt for iOS"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.1/single/qt-everywhere-src-6.1.1.tar.xz"
  sha256 "6ac937aae4c7b5a3eac90ea4d13f31ded9f78ebc93007bb919fae65c58c808c3"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  keg_only "this is Qt SDK for tvOS"

  depends_on "cmake"      => [:build, :test]
  depends_on "ninja"      => :build
  depends_on "pkg-config" => :build

  depends_on "emscripten"
  depends_on "python@3.9"
  depends_on "qt"
  depends_on :xcode

  uses_from_macos "perl"

  def install
    ENV.permit_arch_flags
    ENV.delete "HOMEBREW_SDKROOT"

    inreplace "qtbase/CMakeLists.txt", "FATAL_ERROR", ""

    config_args = %W[
      -release
      -prefix #{prefix}
      -xplatform
      macx-tvos-clang
      -qt-host-path
      #{Formula["qt"].prefix}
    ]

    system "./configure", *config_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    rm bin/"qt-cmake-private-install.cmake"
  end

  test do
    (testpath/"test.pro").write <<~EOS
      QT       += core
      TARGET = test
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<~EOS
      #undef QT_NO_DEBUG
      #include <QCoreApplication>
      #include <QDebug>

      int main(int argc, char *argv[])
      {
        QCoreApplication a(argc, argv);
        return 0;
      }
    EOS

    system bin/"qmake"
    system "make"
    system "./test"
  end
end
