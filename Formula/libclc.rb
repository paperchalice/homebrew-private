class Libclc < Formula
  desc "LLVM OpenCL C implementation"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-12.0.1",
    revision: "fed41342a82f5a3a9201819a82bf7a48313e296b"
  license "Apache-2.0" => { with: "LLVM-exception" }

  depends_on "clang"                 => :build
  depends_on "cmake"                 => :build
  depends_on "llvm-core"             => :build
  depends_on "spirv-llvm-translator" => :build

  def install
    cmake_args = std_cmake_args + %w[
      -D BUILD_SHARED_LIBS=ON
      -D CMAKE_CXX_STANDARD=17

      -S libclc
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
