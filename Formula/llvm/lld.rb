class Lld < Formula
  desc "LLVM Linker"
  homepage "https://lld.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.2/llvm-project-18.1.2.src.tar.xz"
  sha256 "51073febd91d1f2c3b411d022695744bda322647e76e0b4eb1918229210c48d5"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/lld-18.1.2"
    sha256 cellar: :any, ventura: "bfc8d1c9da9abe270c1d5125d6e80b24db13b3cc1ff4169da4b02d8d4009451a"
  end

  depends_on "cmake" => :build

  depends_on "llvm-core"

  def install
    args = std_cmake_args+ %w[
      -D BUILD_SHARED_LIBS=ON

      -S lld
      -B build
    ]

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build", "--strip"
    man1.install "lld/docs/ld.lld.1"
    system "gzip", man1/"ld.lld.1"
  end

  test do
    system "echo"
  end
end
