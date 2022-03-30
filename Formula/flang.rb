class Flang < Formula
  desc "Fortran front end for LLVM"
  homepage "https://flang.llvm.org"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-14.0.0",
    revision: "329fda39c507e8740978d10458451dcdb21563be"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/flang-14.0.0"
    sha256 cellar: :any, monterey: "0db27f8410f635e9208072dcb553e87ec8a0209a96ee2fa396a068387271e391"
  end

  depends_on "cmake"       => :build
  depends_on "sphinx-doc"  => :build

  depends_on "clang"
  depends_on "llvm-core"
  depends_on "mlir"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    cmake_args = std_cmake_args + %W[
      -D BUILD_SHARED_LIBS=ON
      -D CMAKE_CXX_STANDARD=17

      -D CLANG_DIR=#{Formula["clang"].lib}/cmake/clang
      -D LLVM_BUILD_DOCS=OFF
      -D LLVM_INCLUDE_DOCS=ON
      -D LLVM_ENABLE_SPHINX=ON
      -D MLIR_TABLEGEN_EXE=#{Formula["mlir"].bin}/mlir-tblgen
      -D SPHINX_WARNINGS_AS_ERRORS=OFF
      -D SPHINX_OUTPUT_HTML=OFF
      -D SPHINX_OUTPUT_MAN=ON

      -S flang
      -B build
    ]

    system "cmake", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build", "--strip"
  end

  test do
    system "echo"
  end
end
