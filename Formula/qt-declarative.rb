class QtDeclarative < Formula
  desc "Qt Quick2"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.0/submodules/qtdeclarative-everywhere-src-6.1.0.tar.xz"
  sha256 "e6f64314b8d54d7b541f52827b4e795317b17c3b7f39ad5210b8dbf343b75bda"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtdeclarative.git", branch: "dev"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-declarative-6.1.0"
    sha256 cellar: :any, big_sur: "ee40f0893462b4dce23b3bdbf05ddbe96e3c11252b94d4aab393208493a1134b"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "perl" => :build

  depends_on "python"
  depends_on "qt-base"
  depends_on "qt-shader-tools"
  depends_on "qt-svg"

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
      -D CMAKE_INSTALL_PREFIX=#{HOMEBREW_PREFIX}
      -D CMAKE_STAGING_PREFIX=#{prefix}

      -D Python_ROOT_DIR=#{Formula["python"].opt_prefix}
    ]
    system "cmake", ".", *args
    system "cmake", "--build", "."
    system "cmake", "--install", ".", "--strip"

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
