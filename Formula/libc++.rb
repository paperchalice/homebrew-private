class Libcxx < Formula
  desc "LLVM C++ standard library"
  homepage "https://libcxx.llvm.org/"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-14.0.0",
    revision: "329fda39c507e8740978d10458451dcdb21563be"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/libc++-14.0.0"
    sha256 cellar: :any, monterey: "e25b8b1d7e6e53b87ffea49045a666a8bd502db1ebdf516bd26f07cd5167aefe"
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
