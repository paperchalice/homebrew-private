class Flang < Formula
  desc "Fortran front end for LLVM"
  homepage "http://flang.llvm.org"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-13.0.0",
    revision: "d7b669b3a30345cfcdb2fde2af6f48aa4b94845d"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/flang-12.0.1"
    sha256 cellar: :any, big_sur: "92049324d48a9dfa969496d49a27bf3ea0524b166415de9ad1e562db4adbcade"
  end

  depends_on "cmake" => :build

  depends_on "llvm-core"
  depends_on "mlir"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    args = std_cmake_args + %W[
      -D BUILD_SHARED_LIBS=ON
      -D CMAKE_CXX_STANDARD=17

      -D MLIR_TABLEGEN_EXE=#{Formula["mlir"].bin}/mlir-tblgen
      -D FLANG_BUILD_NEW_DRIVER=OFF
      -D FLANG_INCLUDE_TESTS=OFF
      -S flang
      -B build
    ]

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build", "--strip"
  end

  test do
    system "echo"
  end
end
