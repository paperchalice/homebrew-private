class Libcxx < Formula
  desc "LLVM C++ standard library"
  homepage "https://libcxx.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.1/llvm-project-17.0.1.src.tar.xz"
  sha256 "b0e42aafc01ece2ca2b42e3526f54bebc4b1f1dc8de6e34f46a0446a13e882b9"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/libc++-17.0.1"
    sha256 cellar: :any, ventura: "0f62ba47cb259bb0e0bf52d6fdfb44a88ae809fe6b2e3cf3f99b71a9602f5dbb"
  end

  depends_on "cmake" => :build

  depends_on "libc++abi"

  def install
    cmake_args = std_cmake_args+ %w[
      -D LLVM_ENABLE_RUNTIMES=libcxx;libcxxabi

      -S runtimes
      -B build
    ]

    system "cmake", *cmake_args
    system "cmake", "--build", "build", "--target", "install-cxx-stripped"

    MachO::Tools.change_install_name "#{lib}/#{shared_library "libc++"}",
                                     "@rpath/#{shared_library "libc++abi", 1}",
                                     "#{Formula["libc++abi"].lib}/#{shared_library "libc++abi", 1}"
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
