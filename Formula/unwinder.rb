class Unwinder < Formula
  desc "LLVM unwinding library"
  homepage "https://libcxx.llvm.org/"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-12.0.1",
    revision: "fed41342a82f5a3a9201819a82bf7a48313e296b"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/unwinder-12.0.1"
    sha256 cellar: :any, big_sur: "f2569bde4e938aa261f42460b0b117f4e21e7f1d80e06178abab2e1a49c08bf7"
  end

  depends_on "cmake" => :build

  depends_on "compiler-rt"

  def install
    args = std_cmake_args+ %w[
      -D LIBUNWIND_USE_COMPILER_RT=ON

      -S libunwind
      -B build
    ]

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build", "--strip"
  end

  test do
    (testpath/"main.c").write <<~EOS
      #include <assert.h>
      #include <libunwind.h>

      int main(int argc, char* argv[]) {
        unw_context_t context;
        int ret = unw_getcontext(&context);
        assert(ret == UNW_ESUCCESS);
        return 0;
      }
    EOS
    system ENV.cc, "main.c"
    system "./a.out"
  end
end
