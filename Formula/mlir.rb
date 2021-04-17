class Mlir < Formula
  desc "Multi-Level Intermediate Representation"
  homepage "https://mlir.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.0/llvm-project-12.0.0.src.tar.xz"
  sha256 "9ed1688943a4402d7c904cc4515798cdb20080066efa010fe7e1f2551b423628"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url "https://llvm.org/"
    regex(/LLVM (\d+\.\d+\.\d+)/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/mlir-12.0.0"
    sha256 cellar: :any, big_sur: "0e9b59cb044c9f1f1f3f75fb5c77adf882b13de51b1ad63b27c9e4bb86112084"
  end

  depends_on "cmake" => :build

  depends_on "llvm-core"

  patch do
    url "https://github.com/llvm/llvm-project/commit/2aa1af9b1da0d832270d9b8afcba19a4aba2c366.patch?full_index=1"
    sha256 "9eef2025e3e4401e705426b3bf9af7a04ab0fbb4c3cc055dded6e16addec1d79"
  end

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_BUILD_TYPE"] } + %w[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_BUILD_TYPE=MinSizeRel
      -DCMAKE_CXX_STANDARD=17
    ]

    cd "mlir" do
      mkdir "build" do
        system "cmake", "..", *args
        system "cmake", "--build", "."
        system "cmake", "--install", "."
        prefix.install "bin"
      end
    end
  end

  test do
    system "echo"
  end
end
