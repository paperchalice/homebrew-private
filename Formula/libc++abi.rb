class Libcxxabi < Formula
  desc "C++ Standard Library Support"
  homepage "https://libcxxabi.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.0/llvm-project-12.0.0.src.tar.xz"
  sha256 "9ed1688943a4402d7c904cc4515798cdb20080066efa010fe7e1f2551b423628"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    url "https://llvm.org/"
    regex(/LLVM (\d+\.\d+\.\d+)/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/libc++abi-12.0.0"
    sha256 cellar: :any, big_sur: "bc1c541e8b055a67b5c05bf3c41c0efcf42d9848d2cbbf7ef656da2e87f3f61e"
  end

  depends_on "cmake" => :build
  depends_on "python" => :build

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_BUILD_TYPE"] } +  %W[
      -DCMAKE_BUILD_TYPE=MinSizeRel
    ]

    cd "libcxxabi" do
      mkdir "build" do
        system "cmake", "..", *args
        system "cmake", "--build", "."
        system "cmake", "--install", "."
      end
    end
  end

  test do
    system "echo"
  end
end
