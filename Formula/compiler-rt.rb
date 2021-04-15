class CompilerRt < Formula
  desc "Highly tuned implementations of the low-level code generator support routines"
  homepage "https://compiler-rt.llvm.org"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.0/compiler-rt-12.0.0.src.tar.xz"
  sha256 "85a8cd0a62413eaa0457d8d02f8edac38c4dc0c96c00b09dc550260c23268434"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    url "https://llvm.org/"
    regex(/LLVM (\d+\.\d+\.\d+)/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/compiler-rt-11.1.0"
    sha256 cellar: :any, big_sur: "09a833097ba26b5ac56d574c120f554c30e209bb9db579741314f48c091e0faf"
  end

  depends_on "cmake" => :build
  depends_on "llvm-core" => :build
  depends_on "ninja" => :build

  def install
    args = %W[
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_INSTALL_PREFIX=#{lib}/clang/#{Formula["llvm-core"].version}
    ]

    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *(std_cmake_args + args)
      system "cmake", "--build", "."
      system "cmake", "--install", "."
    end
  end

  test do
    system "echo"
  end
end
