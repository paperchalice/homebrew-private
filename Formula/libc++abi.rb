class Libcxxabi < Formula
  desc "C++ Standard Library Support"
  homepage "https://libcxxabi.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.0/llvm-project-12.0.0.src.tar.xz"
  sha256 "9ed1688943a4402d7c904cc4515798cdb20080066efa010fe7e1f2551b423628"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/libc++abi-12.0.0"
    sha256 cellar: :any, big_sur: "bc1c541e8b055a67b5c05bf3c41c0efcf42d9848d2cbbf7ef656da2e87f3f61e"
  end

  depends_on "cmake" => :build
  depends_on "python" => :build

  depends_on "compiler-rt"
  depends_on "unwinder"

  def install
    args = std_cmake_args+ %w[
      -D LIBCXXABI_USE_LLVM_UNWINDER=ON
      -D LIBCXXABI_USE_COMPILER_RT=ON

      .
    ]

    cd "libcxxabi"
    system "cmake", *args
    system "cmake", "--build", "."
    system "cmake", "--install", "."
  end

  test do
    (testpath/"test.c").write <<~EOS
      void __cxa_end_catch();
      int main(void) {
        __cxa_end_catch();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lc++abi"
    assert_includes MachO::Tools.dylibs("a.out"), "#{opt_lib}/libc++abi.1.dylib"
  end
end
