class Polly < Formula
  desc "High-level loop and data-locality optimizer"
  homepage "https://polly.llvm.org/"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-14.0.0",
    revision: "329fda39c507e8740978d10458451dcdb21563be"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/polly-14.0.0"
    sha256 cellar: :any, monterey: "047120500b551e48ef3df90e288e36e5707d299646c2c2658af41181da9266d8"
  end

  depends_on "cmake"      => :build
  depends_on "pkgconf"    => :build

  depends_on "isl"
  depends_on "llvm-core"

  def install
    cd "polly"
    mkdir_p "include/isl"
    cp "lib/External/isl/include/isl/isl-noexceptions.h", "include/isl/isl-noexceptions.h"
    cmake_args = std_cmake_args+ %w[
      -D BUILD_SHARED_LIBS=ON
      -D CMAKE_CXX_STANDARD=17

      -D POLLY_BUNDLED_ISL=ON
      -D POLLY_ENABLE_GPGPU_CODEGEN=OFF

      -S .
      -B build
    ]

    system "cmake", *cmake_args
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
