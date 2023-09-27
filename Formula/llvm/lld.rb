class Lld < Formula
  desc "LLVM Linker"
  homepage "https://lld.llvm.org/"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-14.0.6",
    revision: "f28c006a5895fc0e329fe15fead81e37457cb1d1"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/lld-14.0.6"
    sha256 cellar: :any, monterey: "5d73419d13816aa7d35e35a611e424be0f533bfab41a3de4faa7890dc3ffd948"
  end

  depends_on "cmake" => :build

  depends_on "llvm-core"

  patch do
    url "https://github.com/llvm/llvm-project/commit/94e0f8e.patch?full_index=1"
    sha256 "4d1c0ad421e060f3557aadc5be94e8b1dcd80ebf62973bd5664e1f5b2de84ef4"
  end

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
    system "gzip", man1/"ld.lld.1"
  end

  test do
    system "echo"
  end
end
