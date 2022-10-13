class QtOpcua < Formula
  desc "Qt wrapper for existing OPC UA stacks"
  homepage "https://www.qt.io/"
  url "https://github.com/qt/qtopcua/archive/refs/tags/v6.4.0.tar.gz"
  sha256 "f68eb8a2582f1d07405974814d43284a90b65f959c7a69e4c4e1727925e223b5"
  license "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" }

  depends_on "cmake" => [:build, :test]

  depends_on "open62541"
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
