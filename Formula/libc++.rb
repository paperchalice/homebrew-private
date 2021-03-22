class Libcxx < Formula
  desc "LLVM C++ standard library"
  homepage "https://libcxx.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.1.0/llvm-project-11.1.0.src.tar.xz"
  sha256 "74d2529159fd118c3eac6f90107b5611bccc6f647fdea104024183e8d5e25831"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    url "https://llvm.org/"
    regex(/LLVM (\d+\.\d+\.\d+)/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/libc++-11.1.0"
    sha256 cellar: :any, big_sur: "a310ff4b7a2555a0a2852f8045d56f761ec396fe353749e46bed32a9d943ff34"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  depends_on "compiler-rt"
  depends_on "paperchalice/private/libunwind"

  def install
    cd "libcxx" do
      args = %W[
        -DLIBCXX_CXX_ABI=libcxxabi
        -DLIBCXXABI_USE_LLVM_UNWINDER:BOOL=ON
        -DLIBCXX_INSTALL_HEADER_PREFIX=#{prefix}/
        -DLIBCXX_INSTALL_PREFIX=#{prefix}/
        -DLIBCXX_USE_COMPILER_RT:BOOL=ON
      ]
      mkdir "build" do
        system "cmake", "-G", "Ninja", "..", *(std_cmake_args + args)
        system "ninja"
        system "ninja", "install"
      end
    end

    cd "libcxxabi" do
      mkdir "build" do
        system "cmake", "-G", "Ninja", "..", *std_cmake_args
        system "ninja"
        system "ninja", "install"
      end
    end
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
    assert_match "#{opt_lib}/libc++.1.dylib", shell_output("otool -L a.out")
  end
end
