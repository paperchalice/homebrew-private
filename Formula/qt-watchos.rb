class QtWatchOS < Formula
  desc "Qt for watchOS"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.0/6.0.2/single/qt-everywhere-src-6.0.2.tar.xz"
  sha256 "67a076640647783b95a907d2231e4f34cec69be5ed338c1c1b33124cadf10bdf"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  revision 1

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-ios-6.0.2_1"
    sha256 big_sur: "60f23617add7f15215016a0053a5e9524869df69f0635ce5356ac4d4e3dbe84f"
  end

  keg_only "this is Qt SDK for TVOS"

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "qt"
  depends_on :xcode

  uses_from_macos "perl"

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
    ]

    system "./configure", "-xplatform", "macx-watchos-clang",
      "-qt-host-path", Formula["qt"].prefix.to_s, "--", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    rm bin/"qt-cmake-private-install.cmake"
    libexec.install bin/"target_qt.conf"
    libexec.install bin/"qmake"
    bin.write_exec_script libexec/"qmake"
  end

  test do
    ENV.delete "CPATH"
    (testpath/"test.pro").write <<~EOS
      QT       += core
      TARGET = test
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QCoreApplication>

      int main(int argc, char *argv[])
      {
        QCoreApplication a(argc, argv);
        return 0;
      }
    EOS

    system bin/"qmake", "test.pro"
    cmd = 'xcodebuild CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO'
    system cmd
    assert_predicate testpath/"Release-iphoneos/test.app", :exist?
  end
end
