class Libunwind < Formula
  desc "LLVM unwinding library"
  homepage "https://libcxx.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.5/llvm-project-19.1.5.src.tar.xz"
  sha256 "bd8445f554aae33d50d3212a15e993a667c0ad1b694ac1977f3463db3338e542"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/libunwind-19.1.5"
    sha256 cellar: :any, ventura: "79ec42cac9478ffd55fa00416ab05c15a8da17a2512e19fd819dc5cd66e7e410"
  end

  depends_on "cmake" => :build

  def install
    cmake_args = std_cmake_args+ %w[
      -D LLVM_ENABLE_RUNTIMES=libunwind

      -S runtimes
      -B build
    ]
    build_args = %w[
      --build
      build
      --target
      install-unwind-stripped
    ]

    system "cmake", *cmake_args
    system "cmake", *build_args
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
