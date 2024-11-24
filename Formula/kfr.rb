class Kfr < Formula
  desc "Fast, modern C++ DSP framework"
  homepage "https://www.kfrlib.com/"
  url "https://github.com/kfrlib/kfr/archive/refs/tags/6.1.0.tar.gz"
  sha256 "551205da23b203daac176a2a76c628e3ad188b9b786e651294bf7ad3e72a9aaf"
  license "GPL-2.0-or-later"

  depends_on "cmake" => :build

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DKFR_ENABLE_CAPI_BUILD=ON" if ENV.compiler == :clang

    system "cmake", "-S", ".", "-B", "build", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <kfr/io.hpp>

      using namespace kfr;

      int main() {
        println("Hello KFR!");
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-lkfr_io",
                    "-o", "test"
    assert_equal "Hello KFR!", shell_output("./test").chomp
  end
end
