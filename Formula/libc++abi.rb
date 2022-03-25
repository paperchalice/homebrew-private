class Libcxxabi < Formula
  desc "C++ Standard Library Support"
  homepage "https://libcxxabi.llvm.org/"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-13.0.0",
    revision: "d7b669b3a30345cfcdb2fde2af6f48aa4b94845d"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/libc++abi-13.0.0"
    sha256 cellar: :any, big_sur: "52d3880879bc4d4242fcc9007998790a4456ad62c8ed084cc11f878f422d8899"
  end

  depends_on "cmake"       => :build
  depends_on "compiler-rt" => :build
  depends_on "python"      => :build

  depends_on "paperchalice/private/libunwind"

  def install
    inreplace "libcxx/cmake/Modules/MacroEnsureOutOfSourceBuild.cmake", "FATAL_ERROR", ""
    libcxx_args = %w[
      -S libcxx
      -B libcxx/build
    ]
    system "cmake", *libcxx_args
    (buildpath/"libcxx/include").install buildpath/"libcxx/build/include/c++/v1/__config_site"
    args = std_cmake_args+ %W[
      -D LIBCXXABI_USE_LLVM_UNWINDER=ON
      -D LIBCXXABI_USE_COMPILER_RT=ON
      -D LIBCXXABI_LIBCXX_INCLUDES=#{buildpath}/libcxx/include

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
