class Libcxx2 < Formula
  desc "LLVM C++ standard library (unstable ABI)"
  homepage "https://libcxx.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.0/llvm-project-20.1.0.src.tar.xz"
  sha256 "4579051e3c255fb4bb795d54324f5a7f3ef79bd9181e44293d7ee9a7f62aad9a"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/libc++2-20.1.0"
    sha256 ventura: "ec4b0a51ceafdfcf4fdbe3fd3588e31aaaec395be5a94d155b42005eed99a0d8"
  end

  depends_on "clang" => :build
  depends_on "cmake" => :build

  depends_on "libc++abi"
  depends_on "tzdb"
  depends_on "unwind"

  def install
    inreplace "libcxx/src/experimental/tzdb.cpp" do |s|
      tzdb = Formula["tzdb"]
      s.gsub! "__linux__", "__APPLE__"
      s.gsub! "/usr/share/zoneinfo/", "#{tzdb.share}/zoneinfo/"
    end

    clang = Formula["clang"]
    ENV["CC"] = clang.bin/"clang"
    ENV["CXX"] = clang.bin/"clang++"

    libunwind = Formula["unwind"]
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
