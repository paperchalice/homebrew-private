class Mlir < Formula
  desc "Multi-Level Intermediate Representation"
  homepage "https://mlir.llvm.org/"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-14.0.6",
    revision: "f28c006a5895fc0e329fe15fead81e37457cb1d1"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/mlir-14.0.6"
    sha256 cellar: :any, monterey: "b15054a3ec861e367293dec830983abd4ba2df89566ff9642a8f3a177f5a133b"
  end

  depends_on "cmake" => :build
  depends_on "lld"   => :build

  depends_on "llvm-core"
  depends_on "numpy"
  depends_on "pybind11"
  depends_on "python"

  def install
    cmake_args = std_cmake_args+ %w[
      -D BUILD_SHARED_LIBS=ON
      -D CMAKE_CXX_STANDARD=17
      -D CMAKE_CXX_FLAGS=-fuse-ld=lld

      -D LLVM_BUILD_TOOLS=ON
      -D LLVM_BUILD_UTILS=ON
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
