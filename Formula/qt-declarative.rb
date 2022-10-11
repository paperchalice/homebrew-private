class QtDeclarative < Formula
  desc "Qt Quick2"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.4/6.4.0/submodules/qtdeclarative-everywhere-src-6.4.0.tar.xz"
  sha256 "3434e72fccfa0c929c326790723d05c155f5067746b1ab05cfd7a9ba632c4383"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]
  head "https://code.qt.io/qt/qtdeclarative.git", branch: "dev"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/qt-declarative-6.4.0"
    sha256 cellar: :any, monterey: "0534398164dfa01aaede8f74b1f0ce63118cdfbbcd28b85c90b8135b6eaa4a96"
  end

  depends_on "cmake"           => [:build, :test]
  depends_on "perl"            => :build
  depends_on "pkgconf"         => :build
  depends_on "python"          => :build
  depends_on "qt-shader-tools" => :build
  depends_on "vulkan-headers"  => [:build, :test]

  depends_on "qt-base"

  def install
    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX) + %W[
      -D CMAKE_STAGING_PREFIX=#{prefix}

      -D Python_ROOT_DIR=#{Formula["python"].prefix}

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
