class Libcxx < Formula
  desc "LLVM C++ standard library"
  homepage "https://libcxx.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.2/llvm-project-18.1.2.src.tar.xz"
  sha256 "51073febd91d1f2c3b411d022695744bda322647e76e0b4eb1918229210c48d5"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/libc++-18.1.2"
    rebuild 1
    sha256 cellar: :any, ventura: "4da59e6cdfd5ffeda34a5dbda4ab2823121d04c81e943f7e3d36afaa2cf3c151"
  end

  depends_on "cmake" => :build

  depends_on "libc++abi"

  def install
    inreplace "libcxx/src/experimental/tzdb.cpp" do |s|
      tzdb = Formula["tzdb"]
      s.gsub! "__linux__", "__APPLE__"
      s.gsub! "/usr/share/zoneinfo/", "#{tzdb.share}/zoneinfo/"
    end

    libunwind = Formula["paperchalice/private/libunwind"]
    libcxxabi = Formula["libc++"]
    rpaths = [libunwind.opt_lib, libcxxabi.opt_lib]
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
