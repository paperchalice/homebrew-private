class Libcxxabi < Formula
  desc "C++ Standard Library Support"
  homepage "https://libcxxabi.llvm.org/"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-12.0.1",
    revision: "fed41342a82f5a3a9201819a82bf7a48313e296b"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/libc++abi-12.0.1"
    sha256 cellar: :any, big_sur: "e05be1057efaca7918f961b524582ec1e3cce8273362104cf030688d1af3d048"
  end

  depends_on "cmake"       => :build
  depends_on "python"      => :build
  depends_on "compiler-rt" => :build

  depends_on "unwinder"

  def install
    args = std_cmake_args+ %w[
      -D LIBCXXABI_USE_LLVM_UNWINDER=ON
      -D LIBCXXABI_USE_COMPILER_RT=ON

      -S libcxxabi
      -B build
    ]

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build", "--strip"
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
