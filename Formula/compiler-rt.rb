class CompilerRt < Formula
  desc "Highly tuned implementations of the low-level code generator support routines"
  homepage "https://compiler-rt.llvm.org"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-12.0.1",
    revision: "fed41342a82f5a3a9201819a82bf7a48313e296b"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/compiler-rt-12.0.1"
    sha256 cellar: :any, big_sur: "56ae098406910361e20d7fbfaad958952b4bff9db0121ac73d8e698917809342"
  end

  depends_on "cmake"     => :build
  depends_on "llvm-core" => :build
  depends_on xcode: [:build, :test]

  def install
    args = std_cmake_args + %W[
      -D CMAKE_CXX_FLAGS=-w\ -std=c++14
      -D CMAKE_INSTALL_PREFIX=#{lib}/clang/#{Formula["llvm-core"].version}
      -D COMPILER_RT_ENABLE_IOS=ON
      -D COMPILER_RT_ENABLE_TVOS=OFF
      -D COMPILER_RT_ENABLE_WATCHOS=OFF
      -D COMPILER_RT_USE_BUILTINS_LIBRARY=ON

      -S compiler-rt
      -B build
    ]

    ENV.permit_arch_flags
    ENV.delete "HOMEBREW_OPTFLAGS"

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build", "--strip"
  end

  test do
    (testpath/"test.c").write <<~EOS
      double __floatundidf(int a);
      int main(void) {
        __floatundidf(0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
  end
end
