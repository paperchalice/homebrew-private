class QtBase < Formula
  desc "Base components of Qt framework (Core, Gui, Widgets, Network, ...)"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.3/6.3.1/submodules/qtbase-everywhere-src-6.3.1.tar.xz"
  sha256 "0a64421d9c2469c2c48490a032ab91d547017c9cc171f3f8070bc31888f24e03"
  license all_of: [
    "Apache-2.0",
    "BSD-3-Clause",
    "BSL-1.0",
    "GFDL-1.3-no-invariants-only",
    "GPL-2.0-only"  => { with: "Qt-GPL-exception-1.0" },
    "GPL-3.0-only"  => { with: "Qt-GPL-exception-1.0" },
    "LGPL-3.0-only" => { with: "Qt-LGPL-exception-1.1" },
  ]
  head "https://code.qt.io/qt/qtbase.git", branch: "dev"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-base-6.3.0"
    sha256 cellar: :any, monterey: "5e95c6e987c3fe577dbc2d2d59fea111c62333c95bd8abe0a9d9f9a134cd5eeb"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "molten-vk"  => :build
  depends_on "ninja"      => :build
  depends_on "perl"       => :build
  depends_on "pkgconf"    => :build
  depends_on "vulkan-headers" => :build

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
  depends_on "pcre2"
  depends_on "zstd"

  uses_from_macos "cups"
  uses_from_macos "krb5"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    ENV.permit_arch_flags
    inreplace "cmake/FindGSSAPI.cmake", "gssapi_krb5", ""
    inreplace "CMakeLists.txt", /^qt_internal_check_if_path_has_symlinks/, "#"

    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX) + %W[
      -D CMAKE_STAGING_PREFIX=#{prefix}
      -D CMAKE_SYSROOT=#{MacOS.sdk_path}

      -D INSTALL_DATADIR=share/qt
      -D INSTALL_ARCHDATADIR=share/qt

      -D INSTALL_EXAMPLESDIR=share/qt/examples
      -D INSTALL_MKSPECSDIR=share/qt/mkspecs
      -D INSTALL_TESTSDIR=share/qt/tests

      -D FEATURE_optimize_size=ON
      -D FEATURE_pkg_config=ON
      -D FEATURE_reduce_exports=ON
      -D FEATURE_vulkan=ON
      -D FEATURE_zstd=ON
      -D FEATURE_relocatable=OFF
      -D FEATURE_sql_odbc=OFF
      -D FEATURE_sql_psql=OFF
      -D FEATURE_sql_mysql=OFF
      -D FEATURE_system_harfbuzz=ON
      -D FEATURE_system_sqlite=ON

      -S .
      -G Ninja
    ]

    system "cmake", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", ".", "--strip"

    rm bin/"qt-cmake-private-install.cmake"
    inreplace lib/"cmake/Qt6/qt.toolchain.cmake", Superenv.shims_path, "/usr/bin"

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
      find_package(Qt6 COMPONENTS Widgets REQUIRED)
      add_executable(test
          main.cpp
      )
      target_link_libraries(test PRIVATE Qt6::Widgets)
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
  end
end
