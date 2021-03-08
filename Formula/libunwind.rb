class Libunwind < Formula
  desc "LLVM unwinding library"
  homepage "https://libcxx.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.1.0/llvm-project-11.1.0.src.tar.xz"
  sha256 "74d2529159fd118c3eac6f90107b5611bccc6f647fdea104024183e8d5e25831"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    url "https://llvm.org/"
    regex(/LLVM (\d+\.\d+\.\d+)/i)
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    cd "libunwind" do
      mkdir "build" do
        system "cmake", "-G", "Ninja", "..", *std_cmake_args
        system "ninja"
        system "ninja", "install"
      end
    end
  end

  test do
    system "echo"
  end
end
