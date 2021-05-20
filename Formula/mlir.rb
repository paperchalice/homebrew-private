class Mlir < Formula
  desc "Multi-Level Intermediate Representation"
  homepage "https://mlir.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.0/llvm-project-12.0.0.src.tar.xz"
  sha256 "9ed1688943a4402d7c904cc4515798cdb20080066efa010fe7e1f2551b423628"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/mlir-12.0.0"
    sha256 cellar: :any, big_sur: "353571030a55c946eaba584c74b1f629c0feff44aae2994b09259f8d69cfc8f6"
  end

  depends_on "cmake" => :build

  depends_on "llvm-core"

  patch do
    url "https://github.com/llvm/llvm-project/commit/2aa1af9b1da0d832270d9b8afcba19a4aba2c366.patch?full_index=1"
    sha256 "9eef2025e3e4401e705426b3bf9af7a04ab0fbb4c3cc055dded6e16addec1d79"
  end

  def install
    args = std_cmake_args+ %w[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_CXX_STANDARD=17
    ]

    cd "mlir" do
      mkdir "build" do
        system "cmake", "..", *args
        system "cmake", "--build", "."
        system "cmake", "--install", ".", "--strip"
        prefix.install "bin"
      end
    end
  end

  test do
    system "echo"
  end
end
