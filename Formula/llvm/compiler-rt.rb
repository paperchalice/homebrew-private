class CompilerRt < Formula
  desc "Highly tuned implementations of the low-level code generator support routines"
  homepage "https://compiler-rt.llvm.org"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-14.0.0",
    revision: "329fda39c507e8740978d10458451dcdb21563be"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/compiler-rt-14.0.0"
    sha256 cellar: :any, monterey: "e9d1d27448b30240949e4af2f23cc59048b246fb8cf17c13419602a0bd45a4e5"
  end

  depends_on "cmake"     => :build
  depends_on "llvm-core" => :build
  depends_on xcode: [:build, :test]

  def install
    cmake_args = std_cmake_args + %W[
      -D CMAKE_CXX_FLAGS=-w
      -D CMAKE_CXX_STANDARD=17
      -D CMAKE_INSTALL_PREFIX=#{lib}/clang/#{Formula["llvm-core"].version}
      -D COMPILER_RT_ENABLE_IOS=OFF
      -D COMPILER_RT_ENABLE_TVOS=OFF
      -D COMPILER_RT_ENABLE_WATCHOS=OFF

      -S compiler-rt
      -B build
    ]

    ENV.permit_arch_flags
    ENV.delete "HOMEBREW_OPTFLAGS"
    ENV.prepend "PATH", "/usr/bin:"
    system "cmake", *cmake_args
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
