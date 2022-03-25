class Lld < Formula
  desc "LLVM Linker"
  homepage "https://lld.llvm.org/"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-14.0.0",
    revision: "329fda39c507e8740978d10458451dcdb21563be"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/lld-14.0.0"
    sha256 cellar: :any, monterey: "f6549dfde0fbdeca1f08d0ce2f277412face852854d297cfc3faa5b04dfe4748"
  end

  depends_on "cmake" => :build

  depends_on "llvm-core"

  def install
    args = std_cmake_args+ %w[
      -D BUILD_SHARED_LIBS=ON
      -D CMAKE_CXX_STANDARD=17

      -S lld
      -B build
    ]

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build", "--strip"
    man1.install "lld/docs/ld.lld.1"
  end

  test do
    system "echo"
  end
end
