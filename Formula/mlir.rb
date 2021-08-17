class Mlir < Formula
  desc "Multi-Level Intermediate Representation"
  homepage "https://mlir.llvm.org/"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-13.0.0-rc1",
    revision: "d6974c010878cae1df5b27067230ee5dcbc63342"
  license "Apache-2.0" => { with: "LLVM-exception" }

  depends_on "cmake" => :build

  depends_on "llvm-core"

  patch do
    url "https://github.com/llvm/llvm-project/commit/2aa1af9b1da0d832270d9b8afcba19a4aba2c366.patch?full_index=1"
    sha256 "9eef2025e3e4401e705426b3bf9af7a04ab0fbb4c3cc055dded6e16addec1d79"
  end

  def install
    cd "mlir"

    cmake_args = std_cmake_args+ %w[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_CXX_STANDARD=17

      -S .
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
