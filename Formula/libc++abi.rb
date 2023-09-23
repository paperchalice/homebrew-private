class Libcxxabi < Formula
  desc "C++ Standard Library Support"
  homepage "https://libcxxabi.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.1/llvm-project-17.0.1.src.tar.xz"
  sha256 "b0e42aafc01ece2ca2b42e3526f54bebc4b1f1dc8de6e34f46a0446a13e882b9"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/libc++abi-17.0.1"
    sha256 cellar: :any, ventura: "e63ae33070c4cb8d85664e50e07201bf9f587c5388b8809164600758ecc3a994"
  end

  depends_on "cmake" => :build

  def install
    cmake_args = std_cmake_args+ %w[
      -D LLVM_ENABLE_RUNTIMES=libcxx;libcxxabi

      -S runtimes
      -B build
    ]

    system "cmake", *cmake_args
    build_args = %w[
      --build
      build
      --target
      install-cxxabi-stripped
      install-cxxabi-headers-stripped
    ]
    system "cmake", *build_args
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
