class Mlir < Formula
  desc "Multi-Level Intermediate Representation"
  homepage "https://mlir.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.2/llvm-project-18.1.2.src.tar.xz"
  sha256 "51073febd91d1f2c3b411d022695744bda322647e76e0b4eb1918229210c48d5"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/mlir-18.1.2"
    rebuild 1
    sha256 cellar: :any, ventura: "09a2f6e8fabcd5cdc3890bbfd075794c1809765a1e7b1cc78e3db0cc6387c465"
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

    rm_rf prefix/"src"
    site_package = Language::Python.site_packages "python3"
    (prefix/site_package).install prefix/"python_packages/mlir_core/mlir"
    rm_rf prefix/"python_packages"
  end

  test do
    system "echo"
  end
end
