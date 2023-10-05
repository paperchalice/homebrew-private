class Libcxxabi < Formula
  desc "C++ Standard Library Support"
  homepage "https://libcxxabi.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.2/llvm-project-17.0.2.src.tar.xz"
  sha256 "351562b14d42fcefcbf00cc1f327680a1062bbbf67a1e1ca6acb64c473b06394"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/libc++abi-17.0.1"
    rebuild 1
    sha256 cellar: :any, ventura: "c1b1e47b9afac57aa3ee5e10e843d3693a872a3e4b8fd4145f55951ab0b3999b"
  end

  depends_on "cmake" => :build

  def install
    cmake_args = std_cmake_args+ %w[
      -D LLVM_ENABLE_RUNTIMES=libcxx;libcxxabi

      -S runtimes
      -B build
    ]
    build_args = %w[
      --build
      build
      --target
      install-cxxabi-stripped
      install-cxxabi-headers-stripped
    ]

    system "cmake", *cmake_args
    system "cmake", *build_args
  end

  test do
    (testpath/"test.c").write <<~EOS
      void __cxa_end_catch();
      int main(void) {
        __cxa_end_catch();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lc++abi"
    assert_includes MachO::Tools.dylibs("a.out"), "#{opt_lib}/libc++abi.1.dylib"
  end
end
