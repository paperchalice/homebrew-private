class Libcxx < Formula
  desc "LLVM C++ standard library"
  homepage "https://libcxx.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.5/llvm-project-19.1.5.src.tar.xz"
  sha256 "bd8445f554aae33d50d3212a15e993a667c0ad1b694ac1977f3463db3338e542"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/libc++-19.1.5"
    sha256 cellar: :any, ventura: "8202d54aeb93ffaecd47aec1a9a3b14f2dd3e1c78da52c400ae8bee12b07f652"
  end

  depends_on "clang" => :build
  depends_on "cmake" => :build

  depends_on "libc++abi"
  depends_on "paperchalice/private/libunwind"

  def install
    inreplace "libcxx/src/experimental/tzdb.cpp" do |s|
      tzdb = Formula["tzdb"]
      s.gsub! "__linux__", "__APPLE__"
      s.gsub! "/usr/share/zoneinfo/", "#{tzdb.share}/zoneinfo/"
    end

    clang = Formula["clang"]
    ENV["CC"] = clang.bin/"clang"
    ENV["CXX"] = clang.bin/"clang++"

    libunwind = Formula["paperchalice/private/libunwind"]
    libcxxabi = Formula["libc++abi"]
    rpaths = [rpath, libunwind.opt_lib, libcxxabi.opt_lib]
    cmake_args = std_cmake_args+ %W[
      -D CMAKE_INSTALL_RPATH=#{rpaths.join(";")}
      -D LLVM_ENABLE_RUNTIMES=libcxx;libcxxabi;libunwind
      -D LIBCXX_INSTALL_MODULES=ON
      -D LIBCXX_ENABLE_TIME_ZONE_DATABASE=ON
      -D LIBCXX_ABI_UNSTABLE=ON

      -S runtimes
      -B build
    ]

    system "cmake", *cmake_args
    system "cmake", "--build", "build", "--target", "install-cxx-stripped"
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
  end
end
