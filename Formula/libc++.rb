class Libcxx < Formula
  desc "LLVM C++ standard library"
  homepage "https://libcxx.llvm.org/"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-13.0.0",
    revision: "d7b669b3a30345cfcdb2fde2af6f48aa4b94845d"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/libc++-12.0.1"
    sha256 cellar: :any, big_sur: "8d849f05a2bbed53b1a45f2efc1632fa6e828003a88ad8ae68ce09cebaf6a156"
  end

  depends_on "cmake"       => :build
  depends_on "compiler-rt" => :build

  depends_on "libc++abi"
  depends_on "unwinder"

  def install
    args = std_cmake_args + %w[
      -D CMAKE_SHARED_LINKER_FLAGS=-Wl,-reexport-lc++abi

      -D LIBCXXABI_USE_LLVM_UNWINDER=ON
      -D LIBCXX_CXX_ABI=libcxxabi
      -D LIBCXX_USE_COMPILER_RT=ON

      -S libcxx
      -B build
    ]

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build", "--strip"
  end

  test do
    (testpath/"main.cpp").write <<~EOS
      #include <iostream>
      #include <vector>
      int main() {
        std::vector<int> vec = {1, 2, 3};
        for(const auto &i : vec) {
          std::cout << vec[0] << std::endl;
        }
        return 0;
      }
    EOS
    args = %W[
      -std=c++17
      -nostdlibinc
      -I#{include}/c++/v1
      -L#{lib}
    ]
    system ENV.cxx, "main.cpp", *args
    assert_includes MachO::Tools.dylibs("a.out"), "#{opt_lib}/libc++.1.dylib"
  end
end
