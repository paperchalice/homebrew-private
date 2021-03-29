class QtIos < Formula
  desc "Qt for iOS"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.0/6.0.2/single/qt-everywhere-src-6.0.2.tar.xz"
  sha256 "67a076640647783b95a907d2231e4f34cec69be5ed338c1c1b33124cadf10bdf"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  keg_only "cross tool"

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "qt" => :build

  depends_on :xcode

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
    ENV.prepend "PATH", "/usr/bin"

    cmake_args = std_cmake_args.reject { |s| s["CMAKE_OSX_SYSROOT"]||s["CMAKE_FIND_FRAMEWORK"] } + %w[
      -DCMAKE_FIND_FRAMEWORK=FIRST

      -DINSTALL_TESTSDIR=share/qt/tests
      -DINSTALL_QMLDIR=share/qt/qml
      -DINSTALL_PLUGINSDIR=share/qt/plugins
      -DINSTALL_DESCRIPTIONSDIR=share/qt/modules
      -DINSTALL_DOCDIR=share/doc/qt
      -DINSTALL_MKSPECSDIR=share/qt/mkspecs
      -DINSTALL_TRANSLATIONSDIR=share/qt/translations
      -DINSTALL_EXAMPLESDIR=share/qt/examples
    ]

    system "./configure", "-xplatform", "macx-ios-clang",
      "-qt-host-path", Formula["qt"].prefix.to_s, "--", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    rm bin/"qt-cmake-private-install.cmake"
    prefix.install bin/"target_qt.conf"
  end

  test do
    system "echo"
  end
end
