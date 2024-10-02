class Mlir < Formula
  desc "Multi-Level Intermediate Representation"
  homepage "https://mlir.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.3/llvm-project-18.1.3.src.tar.xz"
  sha256 "2929f62d69dec0379e529eb632c40e15191e36f3bd58c2cb2df0413a0dc48651"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/mlir-18.1.3"
    sha256 cellar: :any, ventura: "157e58975bf57e34adf9adecd2106226ac56c97904c0dd9e1a2e32ae690c1462"
  end

  depends_on "cmake" => :build

  depends_on "llvm-core"
  depends_on "numpy"
  depends_on "pybind11"
  depends_on "python"

  def install
    cmake_args = std_cmake_args+ %W[
      -D BUILD_SHARED_LIBS=ON
      -D MLIR_INSTALL_AGGREGATE_OBJECTS=OFF
      -D Python3_ROOT_DIR=#{Formula["python"].prefix}
      -D Python3_FIND_FRAMEWORK=OFF

      -D LLVM_BUILD_TOOLS=ON
      -D LLVM_BUILD_UTILS=ON
      -D MLIR_ENABLE_BINDINGS_PYTHON=ON

      -S mlir
      -B build
    ]

    system "cmake", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    rm_r prefix/"src"
    site_package = Language::Python.site_packages "python3"
    (prefix/site_package).install prefix/"python_packages/mlir_core/mlir"
    rm_r prefix/"python_packages"
  end

  test do
    system "echo"
  end
end
