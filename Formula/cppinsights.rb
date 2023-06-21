class Cppinsights < Formula
  desc "See your source code with the eyes of a compiler"
  homepage "https://cppinsights.io/"
  url "https://github.com/andreasfertig/cppinsights/archive/refs/tags/v_0.9.tar.gz"
  sha256 "cebb6a062677ee3975ff757e4300a17f42e3fab6da02ad01f3f141fb91f09301"
  license "MIT"

  depends_on "cmake" => :build

  depends_on "llvm@15"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "echo"
  end
end
