class QtBase < Formula
  desc "Base components of Qt framework (Core, Gui, Widgets, Network, ...)"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.3//6.3.2/submodules/qtbase-everywhere-src-6.3.2.tar.xz"
  sha256 "7929ba4df870b6b30870bc0aed2525cfc606ed7091107b23cf7ed7e434caa9a6"
  license all_of: [
    "BSD-3-Clause",
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
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-base-6.3.1"
    sha256 cellar: :any, monterey: "eee4c462b6c4efbf49f1471bfee07658b7615875b58fd9730c62c94e1a234fdb"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "gtk+3"      => :build
  depends_on "molten-vk"  => :build
  depends_on "ninja"      => :build
  depends_on "openssl"    => :build
  depends_on "perl"       => :build
  depends_on "pkgconf"    => :build
  depends_on "vulkan-headers" => :build

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

  uses_from_macos "gzip" => :build

  uses_from_macos "cups"
  uses_from_macos "krb5"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  patch do
    url "https://github.com/paperchalice/homebrew-private/raw/main/Patch/qt-base.diff"
    sha256 "686d3603a183f5196a49bb17a48b03ab52a1b2aa2bff374da5f5c805ea806dab"
  end

  # vulkan: Re-enable VK_KHR_portability drivers
  # TODO: remove in next release
  patch do
    url "https://github.com/qt/qtbase/commit/7fbc741d107ab679f6abd680ec909ce9b2bf333a.patch?full_index=1"
    sha256 "41e4bd41995c446e496a8128f2015443ede7f1b3cd3efe180d62e249cd046540"
    directory "qtbase"
  end

  # vulkan: Add flag to opt out from enumerating Portability phys.devices
  # TODO: remove in next release
  patch do
    url "https://github.com/qt/qtbase/commit/b018bc6e2d27b95024ee8f1b8c719199df47c264.patch?full_index=1"
    sha256 "1b8acf46721100d92e6828206bbde10daa2ed4a020fe7d8f998db80652af6506"
    directory "qtbase"
  end

  def install
    # ENV.permit_arch_flags

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
      FEATURE_system_harfbuzz=ON
      FEATURE_system_sqlite=ON
      FEATURE_system_xcb_xinput=ON
      FEATURE_xcb=ON
      FEATURE_gtk3=ON
    ].map { |o| "-D #{o}" } + %w[
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

    system "gzip", share/"qt/plugins/platformthemes"/shared_library("libqgtk3")
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
    assert_equal "Hello World!", shell_output(testpath/"test 2>&1").strip
    assert_equal HOMEBREW_PREFIX.to_s, shell_output(bin/"qtpaths --query QT_INSTALL_PREFIX").strip
  end
end
