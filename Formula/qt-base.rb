class QtBase < Formula
  desc "Base components of Qt framework (Core, Gui, Widgets, Network, ...)"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.4/6.4.2/submodules/qtbase-everywhere-src-6.4.2.tar.xz"
  sha256 "a88bc6cedbb34878a49a622baa79cace78cfbad4f95fdbd3656ddb21c705525d"
  license all_of: [
    "BSD-3-Clause",
    "GFDL-1.3-no-invariants-only",
    "GPL-2.0-only",
    "LGPL-3.0-only",
    "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" },
  ]
  head "https://code.qt.io/qt/qtbase.git", branch: "dev"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-base-6.4.2"
    sha256 monterey: "7e2696977fd75dcd5b8e7a855d41c1f7f0454f133532db96c235e5532cd5b04f"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "molten-vk"  => [:build, :test]
  depends_on "ninja"      => :build
  depends_on "openssl"    => :build
  depends_on "perl"       => :build
  depends_on "pkgconf"    => :build
  depends_on "vulkan-headers" => [:build, :test]
  depends_on "vulkan-loader" => :test

  depends_on "brotli"
  depends_on "dbus"
  depends_on "double-conversion"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "glib"
  depends_on "harfbuzz"
  depends_on "icu4c"
  depends_on "jpeg-turbo"
  depends_on "libb2"
  depends_on "libpng"
  depends_on "libsm"
  depends_on "libxcb"
  depends_on "libxkbcommon"
  depends_on "md4c"
  depends_on "mesa"
  depends_on "pcre2"
  depends_on "xcb-util-image"
  depends_on "xcb-util-keysyms"
  depends_on "xcb-util-renderutil"
  depends_on "xcb-util-wm"
  depends_on "zstd"

  uses_from_macos "cups"
  uses_from_macos "krb5"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  patch do
    url "https://github.com/paperchalice/homebrew-private/raw/main/Patch/qt-base.diff"
    sha256 "45ddb83062e3fc95aadb49be920620db7cc0860ecc18353d9bf549c2689e7406"
  end

  def install
    ENV.permit_arch_flags
    inreplace "src/gui/CMakeLists.txt", "AND NOT APPLE", ""
    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX) + %W[
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

      QT_FIND_ALL_PACKAGES_ALWAYS=ON
      FEATURE_optimize_size=ON
      FEATURE_pkg_config=ON
      FEATURE_reduce_exports=ON
      FEATURE_vulkan=ON
      FEATURE_zstd=ON
      FEATURE_sql_odbc=OFF
      FEATURE_sql_psql=OFF
      FEATURE_sql_mysql=OFF
      FEATURE_ssl=ON
      FEATURE_fontconfig=ON
      FEATURE_system_harfbuzz=ON
      FEATURE_system_sqlite=ON
      FEATURE_system_xcb_xinput=ON
      FEATURE_xcb=ON
    ].map { |o| "-D #{o}" } + %w[
      -S .
      -G Ninja
    ]

    system "cmake", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", ".", "--strip"

    rm bin/"qt-cmake-private-install.cmake"
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
