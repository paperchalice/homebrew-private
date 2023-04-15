class Mlir < Formula
  desc "Multi-Level Intermediate Representation"
  homepage "https://mlir.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.0/llvm-project-16.0.0.src.tar.xz"
  sha256 "9a56d906a2c81f16f06efc493a646d497c53c2f4f28f0cb1f3c8da7f74350254"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/mlir-16.0.0"
    sha256 cellar: :any, monterey: "5372b0e8d85dfac85bea4519aa14060626354895a025754f78e3babd255b3046"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build

  depends_on "llvm-core"
  depends_on "numpy"
  depends_on "pybind11"
  depends_on "python"

  def install
    cmake_args = std_cmake_args+ %W[
      -D BUILD_SHARED_LIBS=ON
      -D CMAKE_CXX_FLAGS=-fuse-ld=lld
      -D Python3_ROOT_DIR=#{Formula["python"].prefix}
      -D Python3_FIND_FRAMEWORK=OFF

      -D LLVM_BUILD_TOOLS=ON
      -D LLVM_BUILD_UTILS=ON
      -D LLVM_DIR=#{Formula["llvm-core"].lib}/cmake/llvm
      -D MLIR_ENABLE_BINDINGS_PYTHON=ON

      -S mlir
      -B build
    ]

    system "cmake", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    rm_rf prefix/"src"
    site_package = Language::Python.site_packages "python3"
    (prefix/site_package).install prefix/"python_packages/mlir_core/mlir"
    rm_rf prefix/"python_packages"
    rm_rf Dir[lib/"objects-*"]
  end

  test do
    system "echo"
  end
end
