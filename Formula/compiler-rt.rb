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
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/compiler-rt-12.0.0"
    sha256 cellar: :any, big_sur: "1e57935e601da3aa3129f40fdbc6abe58816205abe74b0e9fffbec95d73d86be"
  end

  depends_on "cmake" => :build
  depends_on "llvm-core" => :build

  def install
    args = std_cmake_args + %W[
      -D CMAKE_CXX_STANDARD=17
      -D CMAKE_INSTALL_PREFIX=#{lib}/clang/#{Formula["llvm-core"].version}

      .
    ]

    system "cmake", *args
    system "cmake", "--build", "."
    system "cmake", "--install", "."
  end

  test do
    (testpath/"test.c").write <<~EOS
      double __floatundidf(int a);
      int main(void) {
        __floatundidf(0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
  end
end
