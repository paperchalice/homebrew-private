class QtIos < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.0/6.0.2/single/qt-everywhere-src-6.0.2.tar.xz"
  sha256 "67a076640647783b95a907d2231e4f34cec69be5ed338c1c1b33124cadf10bdf"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qt5.git", branch: "dev", shallow: false

  # The first-party website doesn't make version information readily available,
  # so we check the `head` repository tags instead.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  keg_only "cross"

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "qt"
  depends_on xcode: [:build, :test]

  resource "qtimageformats" do
    url "https://download.qt.io/official_releases/additional_libraries/6.0/6.0.2/qtimageformats-everywhere-src-6.0.2.tar.xz"
    sha256 "b0379ba6bbefbc48ed3ef8a1d8812531bd671362f74e0cffa6adf67bb1139206"
  end

  resource "qt3d" do
    url "https://download.qt.io/official_releases/additional_libraries/6.0/6.0.2/qt3d-everywhere-src-6.0.2.tar.xz"
    sha256 "ff6434da878062aea612a9d7323bd615c2f232c4462c26323f1a5511aac6db89"
  end

  resource "qtnetworkauth" do
    url "https://download.qt.io/official_releases/additional_libraries/6.0/6.0.2/qtnetworkauth-everywhere-src-6.0.2.tar.xz"
    sha256 "05b66ef42f3e6bf4cf5f36744db8483f9a57dbc7bd9ecc9ba81e7ca99b0a37e6"
  end

  def install
    env :std

    resources.each { |addition| addition.stage buildpath/addition.name }

    config_args = %W[
      -xplatform macx-ios-clang
      -qt-host-path #{Formula["qt"].prefix}
      -release

      -libexecdir share/qt/libexec
      -plugindir share/qt/plugins
      -qmldir share/qt/qml
      -docdir share/doc/qt
      -translationdir share/qt/translations
      -examplesdir share/qt/examples
      -testsdir share/qt/tests

      -libproxy
      -no-feature-relocatable
      -system-sqlite
    ]

    cmake_args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"]||s["CMAKE_FIND_FRAMEWORK"] } + %W[
      -DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY

      -DINSTALL_MKSPECSDIR=share/qt/mkspecs
      -DINSTALL_DESCRIPTIONSDIR=share/qt/modules
    ]

    system "./configure", *config_args, "--", *cmake_args
    system "ninja"
    system "ninja", "install"

    rm bin/"qt-cmake-private-install.cmake"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink Dir["#{lib}/*.framework"]

    inreplace lib/"cmake/Qt6/qt.toolchain.cmake", /.*set.__qt_initial_.*/, ""

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    Pathname.glob("#{lib}/*.framework/Headers") do |path|
      include.install_symlink path => path.parent.basename(".framework")
    end

    mkdir libexec
    Pathname.glob("#{bin}/*.app") do |app|
      mv app, libexec
      bin.write_exec_script "#{libexec/app.stem}.app/Contents/MacOS/#{app.stem}"
    end
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.19.0)

      project(test VERSION 1.0.0 LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

      set(CMAKE_AUTOMOC ON)
      set(CMAKE_AUTORCC ON)
      set(CMAKE_AUTOUIC ON)

      find_package(Qt6 COMPONENTS Core Widgets Sql Concurrent
        3DCore Svg Quick3D Network NetworkAuth REQUIRED)

      add_executable(test
          main.cpp
      )

      target_link_libraries(test PRIVATE Qt6::Core Qt6::Widgets
        Qt6::Sql Qt6::Concurrent Qt6::3DCore Qt6::Svg Qt6::Quick3D
        Qt6::Network Qt6::NetworkAuth
      )
    EOS

    (testpath/"test.pro").write <<~EOS
      QT       += core svg 3dcore network networkauth quick3d \
        sql
      TARGET = test
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<~EOS
      #undef QT_NO_DEBUG
      #include <QCoreApplication>
      #include <Qt3DCore>
      #include <QtQuick3D>
      #include <QImageReader>
      #include <QtNetworkAuth>
      #include <QtSql>
      #include <QtSvg>
      #include <QDebug>
      #include <iostream>

      int main(int argc, char *argv[])
      {
        QCoreApplication a(argc, argv);
        QSvgGenerator generator;
        auto *handler = new QOAuthHttpServerReplyHandler();
        delete handler; handler = nullptr;
        auto *root = new Qt3DCore::QEntity();
        delete root; root = nullptr;
        Q_ASSERT(QSqlDatabase::isDriverAvailable("QSQLITE"));
        const auto &list = QImageReader::supportedImageFormats();
        for(const char* fmt:{"bmp", "cur", "gif", "heic", "heif",
          "icns", "ico", "jp2", "jpeg", "jpg", "pbm", "pgm", "png",
          "ppm", "svg", "svgz", "tga", "tif", "tiff", "wbmp", "webp",
          "xbm", "xpm"}) {
          Q_ASSERT(list.contains(fmt));
        }
        return 0;
      }
    EOS

    system "cmake", testpath
    system "make"
    system "./test"

    # Work around "error: no member named 'signbit' in the global namespace"
    ENV.delete "CPATH"
    system bin/"qmake", testpath/"test.pro"
    system "make"
    system "./test"
  end
end
