class Libunwind < Formula
  desc "LLVM unwinding library"
  homepage "https://libcxx.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.0/llvm-project-12.0.0.src.tar.xz"
  sha256 "9ed1688943a4402d7c904cc4515798cdb20080066efa010fe7e1f2551b423628"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    url "https://llvm.org/"
    regex(/LLVM (\d+\.\d+\.\d+)/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/libunwind-12.0.0"
    sha256 cellar: :any, big_sur: "6dbebe9fb98153f1a0c1c1912c19e8432494586470423b077e8e51c1227c5f15"
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_BUILD_TYPE"] } +  %W[
      -DCMAKE_BUILD_TYPE=MinSizeRel
    ]

    cd "libunwind" do
      mkdir "build" do
        system "cmake", "..", *args
        system "cmake", "--build", "."
        system "cmake", "--install", "."
      end
    end
  end

  test do
    (testpath/"main.c").write <<~EOS
      #include <assert.h>
      #include <libunwind.h>

      int main(int argc, char* argv[]) {
        unw_context_t context;
        int ret = unw_getcontext(&context);
        assert(ret == UNW_ESUCCESS);
        return 0;
      }
    EOS
    system ENV.cc, "main.c"
    system "./a.out"
  end
end
