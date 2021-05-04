class QtBase < Formula
  desc "Base components of Qt framework (Core, Gui, Widgets, Network, ...)"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.0/6.0.4/submodules/qtbase-everywhere-src-6.0.4.tar.xz"
  sha256 "1a45b61c2a349964625c50e3ea40cbb309e269762dd0786397e0e18e7e10d394"
  license all_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtbase.git", branch: "dev"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-base-6.0.3"
    sha256 cellar: :any, big_sur: "3fcdd04054a62e1458f1682c1354d644d1907359e455e8e82c0c5e6258567253"
  end

  depends_on "cmake"      => [:build, :test, :recommended]
  depends_on "perl"       => :build
  depends_on "pkg-config" => :build

  depends_on "brotli"
  depends_on "dbus"
  depends_on "double-conversion"
  depends_on "freetype"
  depends_on "glib"
  depends_on "icu4c"
  depends_on "jpeg"
  depends_on "libb2"
  depends_on "libpng"
  depends_on "libproxy"
  depends_on "pcre2"
  depends_on "zstd"

  uses_from_macos "cups"
  uses_from_macos "krb5"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    # TODO: dev is "qmake/qmakelibraryinfo.cpp"
    inreplace "src/corelib/global/qlibraryinfo.cpp", "canonicalPath", "absolutePath"
    inreplace "cmake/FindGSSAPI.cmake", "gssapi_krb5", ""

    cmake_args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
      -D CMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
      -D CMAKE_INSTALL_PREFIX=#{HOMEBREW_PREFIX}
      -D CMAKE_STAGING_PREFIX=#{prefix}

      -D INSTALL_LIBEXECDIR=share/qt/libexec
      -D INSTALL_TESTSDIR=share/qt/tests
      -D INSTALL_QMLDIR=share/qt/qml
      -D INSTALL_PLUGINSDIR=share/qt/plugins
      -D INSTALL_DESCRIPTIONSDIR=share/qt/modules
      -D INSTALL_DOCDIR=share/doc/qt
      -D INSTALL_MKSPECSDIR=share/qt/mkspecs
      -D INSTALL_TRANSLATIONSDIR=share/qt/translations
      -D INSTALL_EXAMPLESDIR=share/qt/examples

      -D FEATURE_pkg_config=ON
      -D FEATURE_libproxy=ON
      -D FEATURE_sql_odbc=OFF
      -D FEATURE_sql_psql=OFF
      -D FEATURE_sql_mysql=OFF
      -D FEATURE_relocatable=OFF

      -D FEATURE_system_sqlite=ON

      .
    ]

    system "cmake", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

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

      find_package(Qt6 COMPONENTS Widgets REQUIRED)

      add_executable(test
          main.cpp
      )

      target_link_libraries(test PRIVATE Qt6::Widgets)
    EOS

    (testpath/"test.pro").write <<~EOS
      QT       += core
      QT       -= gui
      TARGET = test
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QCoreApplication>
      #include <QDebug>

      int main(int argc, char *argv[])
      {
        QCoreApplication a(argc, argv);
        qDebug() << "Hello World!";
        return 0;
      }
    EOS

    system "cmake", testpath
    system "cmake", "--build", "."
    assert_equal "Hello World!", shell_output("#{testpath}/test 2>&1").strip

    system bin/"qmake", testpath/"test.pro"
    system "make"
    assert_equal "Hello World!", shell_output("#{testpath}/test 2>&1").strip
  end
end
