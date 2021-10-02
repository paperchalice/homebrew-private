class Mlir < Formula
  desc "Multi-Level Intermediate Representation"
  homepage "https://mlir.llvm.org/"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-13.0.0",
    revision: "d7b669b3a30345cfcdb2fde2af6f48aa4b94845d"
  license "Apache-2.0" => { with: "LLVM-exception" }

  depends_on "cmake" => :build

  depends_on "llvm-core"
  # TODO: depends_on "numpy"
  # TODO: depends_on "pybind11"
  # TODO: depends_on "python"

  def install
    cd "mlir"

    cmake_args = std_cmake_args+ %w[
      -D BUILD_SHARED_LIBS=OFF
      -D CMAKE_CXX_STANDARD=17

      -D LLVM_BUILD_TOOLS=ON
      -D MLIR_ENABLE_BINDINGS_PYTHON=OFF
      -D MLIR_BINDINGS_PYTHON_LOCK_VERSION=OFF

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
