class QtWasm < Formula
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

  keg_only "sdk"

  depends_on "cmake" => [:build, :test]
  depends_on "emscripten" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: :build

  depends_on "assimp"
  depends_on "dbus"
  depends_on "double-conversion"
  depends_on "freetype"
  depends_on "glib"
  depends_on "icu4c"
  depends_on "jasper"
  depends_on "jpeg"
  depends_on "libb2"
  depends_on "libpng"
  depends_on "libproxy"
  depends_on "libtiff"
  depends_on "pcre2"
  depends_on "python@3.9"
  depends_on "webp"
  depends_on "zstd"

  uses_from_macos "cups"
  uses_from_macos "krb5"
  uses_from_macos "perl"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

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
    resources.each { |addition| addition.stage buildpath/addition.name }

    config_args = %W[
      -release
      -xplatform wasm-emscripten

      -prefix #{HOMEBREW_PREFIX}
      -extprefix #{prefix}

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
      -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
      -DCMAKE_FIND_FRAMEWORK=FIRST

      -DINSTALL_MKSPECSDIR=share/qt/mkspecs
      -DINSTALL_DESCRIPTIONSDIR=share/qt/modules

      -DFEATURE_pkg_config=ON
      -DFEATURE_qt3d_system_assimp=ON
      -DTEST_assimp=ON
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
    system "echo"
  end
end
