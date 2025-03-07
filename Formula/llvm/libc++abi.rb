class Libcxxabi < Formula
  desc "C++ Standard Library Support"
  homepage "https://libcxxabi.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.0/llvm-project-20.1.0.src.tar.xz"
  sha256 "4579051e3c255fb4bb795d54324f5a7f3ef79bd9181e44293d7ee9a7f62aad9a"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/libc++abi-19.1.5"
    sha256 cellar: :any, ventura: "cf2c1285b1ad34f43615d7a1198eed3f22106ed1bfbd13d8db850417a8c5358d"
  end

  depends_on "cmake" => :build

  depends_on "unwind"

  def install
    libunwind = Formula["unwind"]
    cmake_args = std_cmake_args+ %W[
      -D CMAKE_INSTALL_RPATH=#{libunwind.opt_lib}
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
