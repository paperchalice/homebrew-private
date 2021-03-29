class QtIos < Formula
  desc "Qt for iOS"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.0/6.0.2/submodules/qtbase-everywhere-src-6.0.2.tar.xz"
  sha256 "991a0e4e123104e76563067fcfa58602050c03aba8c8bb0c6198347c707817f1"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  keg_only "cross tool"

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "qt"
  depends_on :xcode

  def install
    ENV.prepend "PATH", "/usr/bin"
    # TODO: dev is "qmake/qmakelibraryinfo.cpp"
    inreplace "src/corelib/global/qlibraryinfo.cpp", "canonicalPath", "absolutePath"

    cmake_args = std_cmake_args.reject { |s| s["CMAKE_FIND_FRAMEWORK"] } + %W[
      -DCMAKE_FIND_FRAMEWORK=FIRST
      -DCMAKE_SYSTEM_NAME=iOS
      -DQT_HOST_PATH=#{Formula["qt"].prefix}

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
  end

  test do
    system "echo"
  end
end
