class QtQuickTimeline < Formula
  desc "Module for keyframe-based timeline construction"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.1/6.1.3/submodules/qtquicktimeline-everywhere-src-6.1.3.tar.xz"
  sha256 "2b558f2abe7d6d4b1a500bd8126987e76314e6cd499d365a6476f347b8d2d82a"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtquicktimeline.git", branch: "dev"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-quick-timeline-6.1.2"
    sha256 cellar: :any, big_sur: "2a2dd08c93cd18c0e4872d86013eaf5ad85508d7cd1e9250af651ffae1afdddd"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "perl"       => :build
  depends_on "pkg-config" => :build

  depends_on "qt-base"
  depends_on "qt-declarative"

  def install
    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX) + %W[
      -D CMAKE_STAGING_PREFIX=#{prefix}

      -S .
    ]
    system "cmake", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", ".", "--strip"
  end

  test do
    (testpath/"hello.qml").write <<~EOS
      import QtQuick 2.0
      import QtQuick.Timeline 1.0
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
    system "qmlscene", "--quit", testpath/"hello.qml"
  end
end
