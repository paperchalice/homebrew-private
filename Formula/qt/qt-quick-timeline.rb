class QtQuickTimeline < Formula
  desc "Module for keyframe-based timeline construction"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.6/6.6.0/submodules/qtquicktimeline-everywhere-src-6.6.0.tar.xz"
  sha256 "079e51d4572aed992731628b269f9c3f9c61a6c379bae6c354c949a6d89bb590"
  license all_of: [
    "BSD-3-Clause",
    "GFDL-1.3-no-invariants-only",
    "GPL-2.0-only",
    "LGPL-3.0-only",
    "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" },
  ]
  head "https://code.qt.io/qt/qtquicktimeline.git", branch: "dev"

  livecheck do
    formula "qt"
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-quick-timeline-6.6.0"
    sha256 cellar: :any, ventura: "85d4824cdeb6780b5ac9bac640ba776bfafdda6f03f40973e99a1dbab529435c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

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

    lib.glob("*.framework") do |f|
      frameworks.install_symlink f
      include.install_symlink f/"Headers" => f.stem
      lib.install_symlink f/f.stem => shared_library("lib#{f.stem}")
    end
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
    fork do
      exec "qml", testpath/"hello.qml"
    end
  end
end
