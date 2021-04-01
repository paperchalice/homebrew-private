class QtDeclarative < Formula
  desc "Qt Quick2"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.0/6.0.3/submodules/qtdeclarative-everywhere-src-6.0.3.tar.xz"
  sha256 "f2987fb4c698c5930bbb58e75f7c3de16592f2e79696ed348d77556743db30bd"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtdeclarative.git", branch: "dev"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-declarative-6.0.3"
    sha256 cellar: :any, big_sur: "680755e31d591340d537860afb9f15667d38f7007e4578e33ae746ad6ad455c3"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build

  depends_on "python"
  depends_on "qt-base"
  depends_on "qt-shader-tools"
  depends_on "qt-svg"

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
      -DCMAKE_INSTALL_PREFIX=#{HOMEBREW_PREFIX}
      -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
      -DCMAKE_STAGING_PREFIX=#{prefix}

      -DPython_ROOT_DIR=#{Formula["python"].opt_prefix}
    ]
    system "cmake", "-G", "Ninja", ".", *args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink Dir["#{lib}/*.framework"]

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    Pathname.glob("#{lib}/*.framework/Headers") do |path|
      include.install_symlink path => path.parent.basename(".framework")
    end
  end

  test do
    (testpath/"hello.qml").write <<~EOS
      import QtQuick 2.0
      Rectangle {
          id: page
          width: 320; height: 480
          color: "lightgray"
          Text {
              id: helloText
              text: "Hello world!"
              y: 30
              anchors.horizontalCenter: page.horizontalCenter
              font.pointSize: 24; font.bold: true
          }
      }
    EOS
    system bin/"qmlscene", "--quit", testpath/"hello.qml"
  end
end
