class QtBase < Formula
  desc "Base components of Qt framework (Core, Gui, Widgets, Network, ...)"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.6/6.6.2/submodules/qtbase-everywhere-src-6.6.2.tar.xz"
  sha256 "b89b426b9852a17d3e96230ab0871346574d635c7914480a2a27f98ff942677b"
  license all_of: [
    "BSD-3-Clause",
    "GFDL-1.3-no-invariants-only",
    "GPL-2.0-only",
    "LGPL-3.0-only",
    "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" },
  ]
  head "https://code.qt.io/qt/qtbase.git", branch: "dev"

  livecheck do
    formula "qt"
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-base-6.6.2"
    sha256 ventura: "d4e9b23caac6f74f43cb0eb31b31f0d282be540175f900e776c0403be56622d9"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "molten-vk"  => [:build, :test]
  depends_on "ninja"      => :build
  depends_on "openssl"    => :build
  depends_on "pkgconf"    => :build
  depends_on "vulkan-headers" => [:build, :test]
  depends_on "vulkan-loader" => :test

  depends_on "brotli"
  depends_on "dbus"
  depends_on "double-conversion"
  depends_on "freetype"
  depends_on "glib"
  depends_on "harfbuzz"
  depends_on "icu4c"
  depends_on "jpeg-turbo"
  depends_on "libb2"
  depends_on "libpng"
  depends_on "md4c"
  depends_on "mesa"
  depends_on "pcre2"
  depends_on "zstd"

  uses_from_macos "cups"
  uses_from_macos "krb5"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  patch do
    url "https://github.com/paperchalice/homebrew-private/raw/main/Patch/qt-base.diff"
    sha256 "ca08d700b5e8d658081565226ab763b9ad8ed7960a3beadfd12d89e5a3caadd7"
  end

  def install
    inreplace "cmake/FindWrapOpenGL.cmake", "if(APPLE)", "if(OFF)"
    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST") + %W[
      BUILD_WITH_PCH=OFF
      CMAKE_STAGING_PREFIX=#{prefix}
      CMAKE_SYSROOT=#{MacOS.sdk_path}

      OPENGL_INCLUDE_DIR=#{Formula["mesa"].include}
      OPENGL_gl_LIBRARY=#{Formula["mesa"].lib/shared_library("libGL")}
      OPENGL_glu_LIBRARY=#{Formula["mesa"].lib/shared_library("libGL")}

      INSTALL_DATADIR=share/qt
      INSTALL_ARCHDATADIR=share/qt

      INSTALL_EXAMPLESDIR=share/qt/examples
      INSTALL_MKSPECSDIR=share/qt/mkspecs
      INSTALL_TESTSDIR=share/qt/tests

      FEATURE_optimize_size=ON
      FEATURE_pkg_config=ON
      FEATURE_reduce_exports=ON
      FEATURE_vulkan=ON
      FEATURE_zstd=ON
      FEATURE_sql_odbc=OFF
      FEATURE_sql_psql=OFF
      FEATURE_sql_mysql=OFF
      FEATURE_ssl=ON
      FEATURE_system_harfbuzz=ON
      FEATURE_system_sqlite=ON
    ].map { |o| "-D #{o}" } + %w[
      -S .
      -G Ninja
    ]

    system "cmake", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", ".", "--strip"

    inreplace lib/"cmake/Qt6/qt.toolchain.cmake", "#{Superenv.shims_path}/", ""

    %w[qmake qtpaths].each do |x|
      rm bin/x
      bin.install_symlink bin/"#{x}#{version.major}" => x
    end
    lib.glob("*.framework") do |f|
      frameworks.install_symlink f
      include.install_symlink f/"Headers" => f.stem
      lib.install_symlink f/f.stem => shared_library("lib#{f.stem}")
    end

    # Install a qtversion.xml to ease integration with QtCreator
    # As far as we can tell, there is no ability to make the Qt buildsystem
    # generate this and it's in the Qt source tarball at all.
    # Multiple people on StackOverflow have asked for this and it's a pain
    # to add Qt to QtCreator (the official IDE) without it.
    # Given Qt upstream seems extremely unlikely to accept this: let's ship our
    # own version.
    # If you read this and you can eliminate it or upstream it: please do!
    # More context in https://github.com/Homebrew/homebrew-core/pull/124923
    qtversion_xml = share/"qtcreator/QtProject/qtcreator/qtversion.xml"
    qtversion_xml.dirname.mkpath
    qtversion_xml.write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE QtCreatorQtVersions>
      <qtcreator>
      <data>
        <variable>QtVersion.0</variable>
        <valuemap type="QVariantMap">
        <value type="int" key="Id">1</value>
        <value type="QString" key="Name">Qt %{Qt:Version} (#{HOMEBREW_PREFIX})</value>
        <value type="QString" key="QMakePath">#{opt_bin}/qmake</value>
        <value type="QString" key="QtVersion.Type">Qt4ProjectManager.QtVersion.Desktop</value>
        <value type="QString" key="autodetectionSource"></value>
        <value type="bool" key="isAutodetected">false</value>
        </valuemap>
      </data>
      <data>
        <variable>Version</variable>
        <value type="int">1</value>
      </data>
      </qtcreator>
    XML
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
      find_package(Qt6 COMPONENTS Widgets Gui REQUIRED)
      add_executable(test
          main.cpp
      )
      target_link_libraries(test PRIVATE Qt6::Widgets Qt6::Gui)
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QGuiApplication>
      #include <QVulkanInstance>
      #include <QDebug>
      int main(int argc, char *argv[])
      {
        QGuiApplication app(argc, argv);
        qDebug() << "Hello World!";
        QVulkanInstance inst;
        inst.create();
        return 0;
      }
    EOS

    system "cmake", testpath
    system "cmake", "--build", "."
    system "./test"
    assert_equal HOMEBREW_PREFIX.to_s, shell_output(bin/"qtpaths --query QT_INSTALL_PREFIX").strip
  end
end
