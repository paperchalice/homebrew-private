class Libcxx < Formula
  desc "LLVM C++ standard library"
  homepage "https://libcxx.llvm.org/"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-12.0.1",
    revision: "fed41342a82f5a3a9201819a82bf7a48313e296b"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/libc++-12.0.1"
    sha256 cellar: :any, big_sur: "8d849f05a2bbed53b1a45f2efc1632fa6e828003a88ad8ae68ce09cebaf6a156"
  end

  depends_on "cmake" => :build

  depends_on "compiler-rt"
  depends_on "libc++abi"
  depends_on "unwinder"

  def install
    args = std_cmake_args + %W[
      -D CMAKE_SHARED_LINKER_FLAGS=-Wl,-reexport-lc++abi

      -D LIBCXXABI_USE_LLVM_UNWINDER=ON
      -D LIBCXX_CXX_ABI=libcxxabi
      -D LIBCXX_USE_COMPILER_RT=ON
      -D LIBCXX_INSTALL_HEADER_PREFIX=#{prefix}/
      -D LIBCXX_INSTALL_PREFIX=#{prefix}/
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
