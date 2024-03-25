class Libcxxabi < Formula
  desc "C++ Standard Library Support"
  homepage "https://libcxxabi.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.2/llvm-project-18.1.2.src.tar.xz"
  sha256 "51073febd91d1f2c3b411d022695744bda322647e76e0b4eb1918229210c48d5"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/libc++abi-18.1.2"
    sha256 cellar: :any, ventura: "31fec0bc98dc7dea291a1f70d2d49ec60e0564cc9d28459eea4b5a447fcd8a15"
  end

  depends_on "cmake" => :build

  depends_on "paperchalice/private/libunwind"

  def install
    cmake_args = std_cmake_args+ %w[
      -D LLVM_ENABLE_RUNTIMES=libcxx;libcxxabi;libunwind

      -S runtimes
      -B build
    ]
    build_args = %w[
      --build
      build
      --target
      install-cxxabi-stripped
      install-cxxabi-headers-stripped
    ]

    system "cmake", *cmake_args
    system "cmake", *build_args
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>

      char *__cxa_demangle(const char *mangled_name, char *output_buffer, size_t *length, int *status);

      int main(void) {
        char mangled_name[] = "FvvE";
        int status;
        char *buffer = __cxa_demangle(mangled_name, NULL, NULL, &status);
        puts(buffer);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lc++abi"
    assert_match "void ()", shell_output("./a.out")
  end
end
