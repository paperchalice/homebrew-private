class Mlir < Formula
  desc "Multi-Level Intermediate Representation"
  homepage "https://mlir.llvm.org/"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-14.0.5",
    revision: "c12386ae247c0d46e1d513942e322e3a0510b126"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/mlir-14.0.0"
    sha256 cellar: :any, monterey: "b5704a9d23efadd81fa61e62f210775084e159e40d78bcb714ed5de9640454c6"
  end

  depends_on "cmake" => :build
  depends_on "mold"  => :build

  depends_on "llvm-core"
  depends_on "numpy"
  depends_on "pybind11"
  depends_on "python"

  def install
    cmake_args = std_cmake_args+ %w[
      -D BUILD_SHARED_LIBS=ON
      -D CMAKE_CXX_STANDARD=17
      -D CMAKE_CXX_FLAGS="-fuse-ld=mold"

      -D LLVM_BUILD_TOOLS=ON
      -D LLVM_BUILD_UTILS=ON
      -D MLIR_ENABLE_BINDINGS_PYTHON=ON

      -S mlir
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
