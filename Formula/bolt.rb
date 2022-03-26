class Bolt < Formula
  desc "Binary Optimization and Layout Tool"
  homepage "https://llvm.org/"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-14.0.0",
    revision: "329fda39c507e8740978d10458451dcdb21563be"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/bolt-14.0.0"
    sha256 cellar: :any, monterey: "052acd9d0c4424297861164b3b510399bab57e434c00ef507b68560b475fa975"
  end

  depends_on "cmake"      => :build
  depends_on "sphinx-doc" => :build

  depends_on "llvm-core"

  def install
    cmake_args = std_cmake_args + %W[
      -D BUILD_SHARED_LIBS=ON
      -D CMAKE_CXX_STANDARD=17
      -D CMAKE_INSTALL_RPATH=#{rpath};#{Formula["llvm-core"].lib}

      -D LLVM_ENABLE_EH=ON
      -D LLVM_ENABLE_FFI=ON
      -D LLVM_ENABLE_RTTI=ON
      -D LLVM_INSTALL_UTILS=ON
      -D LLVM_ENABLE_Z3_SOLVER=ON

      -D LLVM_BUILD_DOCS=ON
      -D LLVM_INCLUDE_DOCS=ON
      -D SPHINX_WARNINGS_AS_ERRORS=OFF
      -D SPHINX_OUTPUT_HTML=OFF
      -D SPHINX_OUTPUT_MAN=ON
      -D LLVM_ENABLE_PROJECTS=bolt

      -S llvm
      -B build
    ]

    system "cmake", *cmake_args
    system "cmake", "--build", "build", "-t", "bolt", "install-merge-fdata"
    system "cmake", "--install", "build", "--strip", "--component", "bolt"
    lib.install Dir["build/lib/#{shared_library "libLLVMBOLT*"}"]
  end

  test do
    system "echo"
  end
end
