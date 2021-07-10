class Polly < Formula
  desc "High-level loop and data-locality optimizer"
  homepage "https://polly.llvm.org/"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-12.0.1",
    revision: "fed41342a82f5a3a9201819a82bf7a48313e296b"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/polly-12.0.0"
    sha256 cellar: :any, big_sur: "b796816b1ca1201dbbf7bb0f29727af022d414d34890a7635e9665639d4f111c"
  end

  depends_on "cmake" => :build

  depends_on "isl"
  depends_on "llvm-core"

  def install
    cd "polly"
    mkdir_p "include/isl"
    cp "lib/External/isl/include/isl/isl-noexceptions.h", "include/isl/isl-noexceptions.h"
    args = std_cmake_args+ %w[
      -D BUILD_SHARED_LIBS=ON
      -D CMAKE_CXX_STANDARD=17

      -D POLLY_BUNDLED_ISL=OFF

      -S .
      -B build
    ]

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build", "--strip"
  end

  test do
    (testpath/"test.cpp").write <<~EOF
      #include <polly/>
    EOF
    system "echo"
  end
end
