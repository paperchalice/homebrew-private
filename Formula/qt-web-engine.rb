class QtWebEngine < Formula
  desc "Qt Quick web support"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.2/6.2.0/submodules/qtwebengine-everywhere-src-6.2.0.tar.xz"
  sha256 "c6e530a61bea2e7fbb50308a2b4e7fdb4f7c7b61a28797973270acffc020809d"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtwebengine.git", branch: "dev"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-web-engine-6.2.0"
    rebuild 1
    sha256 cellar: :any, big_sur: "99c778ca08bec64fdb86fe282aaec81f75824cf092851731b6f3daa295a3ea60"
  end

  keg_only "prepared bottle"

  depends_on "cmake"   => [:build, :test]
  depends_on "ninja"   => :build
  depends_on "node"    => :build
  depends_on "perl"    => :build
  depends_on "pkgconf" => :build
  depends_on "python"  => :build
  depends_on "qt"      => :build

  depends_on "qt-base"
  depends_on "qt-declarative"
  depends_on "qt-positioning"
  depends_on "qt-tools"
  depends_on "qt-web-channel"

  uses_from_macos "bison" => :build
  uses_from_macos "flex"  => :build
  uses_from_macos "gperf" => :build

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  def install
    qt = Formula["qt"]

    mkdir_p lib/"cmake/Qt#{version.major}"
    mkdir_p lib/"metatypes"
    mkdir_p share/"qt/modules"
    mkdir_p share/"qt/qml"
    mkdir_p share/"qt/mkspecs/modules"

    (lib/"cmake/Qt#{version.major}").install Dir["cmake/Find*"]
    cp_r qt.lib.glob("QtWebEngine*"), lib
    cp_r (qt.lib/"cmake").glob("qt#{version.major}webengine*"), lib/"metatypes"
    cp_r (qt.lib/"metatypes").glob("Qt#{version.major}WebEngine*"), lib/"cmake"
    cp_r (qt.pkgshare/"modules").glob("WebEngine*"), share/"qt/modules"
    cp_r (qt.pkgshare/"mkspecs/modules").glob("qt_lib_webengine*"), share/"qt/mkspecs/modules"
    cp_r (qt.pkgshare/"qml").glob("QtWebEngine*"), share/"qt/qml"

    # real build steps
    inreplace "src/3rdparty/chromium/build/toolchain/mac/BUILD.gn",
        'rebase_path("$clang_base_path/bin/", root_build_dir)', '""'
    inreplace "src/3rdparty/gn/src/base/files/file_util_posix.cc",
              "FilePath(full_path)", "FilePath(input)"
    %w[
      cmake/Gn.cmake
      cmake/Functions.cmake
      src/core/api/CMakeLists.txt
      src/CMakeLists.txt
      src/gn/CMakeLists.txt
      src/process/CMakeLists.txt
    ].each { |s| inreplace s, "REALPATH", "ABSOLUTE" }

    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX) + %W[
      -D CMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
      -D CMAKE_STAGING_PREFIX=#{prefix}

      -S .
      -G Ninja
    ]
    system "cmake", *cmake_args
    # TODO: system "cmake", "--build", "."
    # TODO: system "cmake", "--install", ".", "--strip"

    lib.glob("*.framework") do |f|
      frameworks.install_symlink f
      include.install_symlink f/"Headers" => f.stem
      lib.install_symlink f/f.stem => shared_library("lib#{f.stem}")
    end
  end

  test do
    system "echo"
  end
end
