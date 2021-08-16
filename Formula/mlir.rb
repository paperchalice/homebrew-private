class Mlir < Formula
  desc "Multi-Level Intermediate Representation"
  homepage "https://mlir.llvm.org/"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-13.0.0-rc1",
    revision: "d6974c010878cae1df5b27067230ee5dcbc63342"
  license "Apache-2.0" => { with: "LLVM-exception" }

  depends_on "cmake" => :build

  depends_on "llvm-core"

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
