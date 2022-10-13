class QtMqtt < Formula
  desc "Qt Module to implement MQTT protocol"
  homepage "https://www.qt.io/"
  url "https://github.com/qt/qtmqtt/archive/refs/tags/v6.4.0.tar.gz"
  sha256 "9820cfc2715cc37e35fabf64979027d740914f072521ffef53359a6bc5e2736a"
  license "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" }

  depends_on "cmake" => [:build, :test]

  depends_on "qt-declarative"

  def install
    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX) + %W[
      -D CMAKE_STAGING_PREFIX=#{prefix}

      -S .
    ]
    system "cmake", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

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
