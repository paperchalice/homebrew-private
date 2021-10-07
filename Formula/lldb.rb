class Lldb < Formula
  desc "Next generation, high-performance debugger"
  homepage "https://lldb.llvm.org/"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-13.0.0",
    revision: "d7b669b3a30345cfcdb2fde2af6f48aa4b94845d"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/lldb-13.0.0"
    sha256 cellar: :any, big_sur: "f4c3c74b04bee8311a5eeb3d96025e78893160191a9e3e2a904e2fbf8047ae98"
  end

  depends_on "cmake" => :build
  depends_on "swig"  => :build

  depends_on "clang"
  depends_on "llvm-core"
  depends_on "lua"
  depends_on "python"
  depends_on "six"
  depends_on "xz"

  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    cmake_args = std_cmake_args + %W[
      -D BUILD_SHARED_LIBS=OFF
      -D CMAKE_CXX_STANDARD=17

      -D Clang_DIR=#{Formula["clang"].lib}/cmake/clang
      -D LLDB_BUILD_FRAMEWORK=OFF
      -D LLDB_USE_SYSTEM_SIX=ON

      -S lldb
      -B build
    ]

    system "cmake", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "echo"
  end
end
