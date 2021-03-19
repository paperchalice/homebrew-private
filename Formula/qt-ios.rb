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

  bottle do
    sha256 cellar: :any, arm64_big_sur: "fb36682730c3261967347efd1e1219970ddcf9e39998183b2aeaa76acad98cce"
    sha256 cellar: :any, big_sur:       "99950b7eb8c3fd4a91f5622f1199b77d99d9d2aa9deeb2e2f11a1ed568f1194b"
    sha256 cellar: :any, catalina:      "30f9131632cfa2088eb24315a5f34090e004413261e11b7290e37d78d7f9e42e"
    sha256 cellar: :any, mojave:        "9498b72fda65897df32aa8ecd754b45d0f02551280170beb6b76e7001d4fff01"
  end

  keg_only "none native"

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "qt" => :build
  depends_on xcode: :build

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
    sdk_version = `xcodebuild -showsdks`.match(/(?<=iphoneos)\d+\.?\d+/)
    sdk_root = `xcrun --sdk iphoneos --show-sdk-path`

    config_args = %W[
      -xplatform macx-ios-clang
      -release

      -qt-host-path #{Formula["qt"].prefix}

      -plugindir share/qt/plugins
      -qmldir share/qt/qml
      -docdir share/doc/qt
      -translationdir share/qt/translations
      -examplesdir share/qt/examples
      -testsdir share/qt/tests

      -no-opengl
      -no-feature-relocatable
    ]

    cmake_args = std_cmake_args.reject { |s| s["CMAKE_OSX_SYSROOT"] } + %W[
      -DCMAKE_OSX_SYSROOT=#{sdk_root}
      -DCMAKE_OSX_ARCHITECTURES=arm64
      -DCMAKE_OSX_DEPLOYMENT_TARGET=#{sdk_version}
      -DCMAKE_CXX_FLAGS=-isystem\ #{MacOS::Xcode.toolchain_path}/usr/include/c++/v1

      -DINSTALL_MKSPECSDIR=share/qt/mkspecs
      -DINSTALL_DESCRIPTIONSDIR=share/qt/modules
    ]

    system "./configure", *config_args, "--", *cmake_args
    system "cmake", "--build", ".", "--parallel"
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
