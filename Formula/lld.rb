class Lld < Formula
  desc "LLVM Linker"
  homepage "https://lld.llvm.org/"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-12.0.1",
    revision: "fed41342a82f5a3a9201819a82bf7a48313e296b"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/lld-12.0.1"
    sha256 cellar: :any, big_sur: "b71f8edb12101be2c5674585e62b081a0b012159c00f211fa096d56656bafcde"
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
  end

  test do
    system "echo"
  end
end
