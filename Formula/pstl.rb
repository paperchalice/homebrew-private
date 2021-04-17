class Pstl < Formula
  desc "Parallel STL"
  homepage "https://software.intel.com/content/www/us/en/develop/articles/get-started-with-parallel-stl.htm"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.0/llvm-project-12.0.0.src.tar.xz"
  sha256 "9ed1688943a4402d7c904cc4515798cdb20080066efa010fe7e1f2551b423628"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    url "https://llvm.org/"
    regex(/LLVM (\d+\.\d+\.\d+)/i)
  end

  depends_on "cmake" => :build

  depends_on "tbb"

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_BUILD_TYPE"] } + %w[
      -DCMAKE_BUILD_TYPE=MinSizeRel

      -DPSTL_PARALLEL_BACKEND=tbb
    ]
    cd "pstl" do
      mkdir "build" do
        system "cmake", "..", *args
        system "cmake", "--build", "."
        system "cmake", "--install", "."
      end
    end
  end

  test do
    system "echo"
  end
end
