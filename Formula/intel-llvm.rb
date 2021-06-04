class IntelLlvm < Formula
  desc "LLVM-based projects"
  homepage "https://www.oneapi.com/"
  url "https://github.com/intel/llvm/archive/refs/tags/2020-12.tar.gz"
  sha256 "191bf63fc2ef14b924fc50deb1af90471da8e4c020b365e852f9a094c6d9fb91"
  license "Apache-2.0" => { with: "LLVM-exception" }

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python" => :build

  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    system "python3", "buildbot/configure.py"
    system "python3", "buildbot/compile.py"
    system "cmake", "--install", "build", "--prefix", prefix
  end

  test do
    system "echo"
  end
end
