class QtCoap < Formula
  desc "Qt Constrained Application Protocol support"
  homepage "https://www.qt.io/"
  url "https://github.com/qt/qtcoap/archive/refs/tags/v6.4.0.tar.gz"
  sha256 "9b3780860d124afce20ca6cc4a52cafe379288676f5f9e4050adb03c873320ca"
  license "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" }

  depends_on "cmake" => [:build, :test]

  depends_on "qt-base"

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
