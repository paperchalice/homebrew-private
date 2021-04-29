class Libcxx < Formula
  desc "LLVM C++ standard library"
  homepage "https://libcxx.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.0/llvm-project-12.0.0.src.tar.xz"
  sha256 "9ed1688943a4402d7c904cc4515798cdb20080066efa010fe7e1f2551b423628"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    url "https://llvm.org/"
    regex(/LLVM (\d+\.\d+\.\d+)/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/libc++-12.0.0"
    sha256 cellar: :any, big_sur: "b142ddb068ed2b2b1599e4d9ddaec11a3b95bb02f56675ed28021c7e6f49f393"
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

      .
    ]

    cd "libcxx"
    system "cmake", *args
    system "cmake", "--build", "."
    system "cmake", "--install", "."
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
