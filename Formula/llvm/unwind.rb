class Unwind < Formula
  desc "LLVM unwinding library"
  homepage "https://libcxx.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.0/llvm-project-20.1.0.src.tar.xz"
  sha256 "4579051e3c255fb4bb795d54324f5a7f3ef79bd9181e44293d7ee9a7f62aad9a"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/unwind-20.1.0"
    sha256 cellar: :any, ventura: "5e1f16aa6603ba61535e78d78b86744bef4cb452ec1b9a854c22b2182af763f7"
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
