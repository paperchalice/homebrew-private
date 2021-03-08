class QtBase < Formula
  desc "Base components of Qt framework (Core, Gui, Widgets, Network, ...)"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.0/6.0.2/submodules/qtbase-everywhere-src-6.0.2.tar.xz"
  sha256 "991a0e4e123104e76563067fcfa58602050c03aba8c8bb0c6198347c707817f1"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-base-6.0.2"
    sha256 cellar: :any, big_sur: "7a452ce7ed4546e68ab63160328e043286e1ec2b0cabe6ede4684b36fbfd65d3"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: :build # for xcodebuild to get version

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
  uses_from_macos "perl"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    # TODO: dev is "qmake/qmakelibraryinfo.cpp"
    inreplace "src/corelib/global/qlibraryinfo.cpp", "canonicalPath", "absolutePath"

    cmake_args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"]||s["CMAKE_FIND_FRAMEWORK"] } + %W[
      -DICU_ROOT=#{Formula["icu4c"].opt_prefix}

      -DCMAKE_FIND_FRAMEWORK=FIRST
      -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
      -DCMAKE_INSTALL_PREFIX=#{HOMEBREW_PREFIX}
      -DCMAKE_STAGING_PREFIX=#{prefix}

      -DINSTALL_LIBEXECDIR=opt/qt-base/libexec
      -DINSTALL_TESTSDIR=share/qt/tests
      -DINSTALL_QMLDIR=share/qt/qml
      -DINSTALL_PLUGINSDIR=share/qt/plugins
      -DINSTALL_DESCRIPTIONSDIR=share/qt/modules
      -DINSTALL_DOCDIR=share/doc/qt
      -DINSTALL_MKSPECSDIR=share/qt/mkspecs
      -DINSTALL_TRANSLATIONSDIR=share/qt/translations
      -DINSTALL_SYSCONFDIR=#{etc}
      -DINSTALL_EXAMPLESDIR=share/qt/examples

      -DFEATURE_pkg_config=ON
      -DFEATURE_libproxy=ON
      -DFEATURE_sql_odbc=OFF
      -DFEATURE_sql_psql=OFF
      -DFEATURE_sql_mysql=OFF
      -DFEATURE_relocatable=OFF

      -DINPUT_sqlite=system
    ]

    system "cmake", "-G", "Ninja", ".", *cmake_args
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

    prefix.install prefix/"opt/qt-base/libexec"
    rm_rf prefix/"opt"
  end

  test do
    assert_equal HOMEBREW_PREFIX.to_s, shell_output("qmake -query QT_INSTALL_PREFIX").strip

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
    system "make"
    assert_equal "Hello World!", shell_output("#{testpath}/test 2>&1").strip

    ENV.delete "CPATH"
    system bin/"qmake", testpath/"test.pro"
    system "make"
    assert_equal "Hello World!", shell_output("#{testpath}/test 2>&1").strip
  end
end
