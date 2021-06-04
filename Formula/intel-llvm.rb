class IntelLlvm < Formula
  desc "LLVM-based projects"
  homepage "https://www.oneapi.com/"
  url "https://github.com/intel/llvm/archive/refs/tags/2020-12.tar.gz"
  sha256 "2cb7d497f3ce33ce8a2c50ad26ec93a8c45f57268d4d96953cd0f25566f753fd"
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
