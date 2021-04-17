class Flang < Formula
  desc "LLVM's Fortran front end"
  homepage "https://flang.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.0/flang-12.0.0.src.tar.xz"
  sha256 "dc9420c9f55c6dde633f0f46fe3f682995069cc5247dfdef225cbdfdca79123a"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    url "https://llvm.org/"
    regex(/LLVM (\d+\.\d+\.\d+)/i)
  end

  depends_on "cmake" => :build

  depends_on "llvm-core"
  depends_on "mlir"

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_BUILD_TYPE"] } + %w[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_BUILD_TYPE=MinSizeRel
      -DCMAKE_CXX_STANDARD=17
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "cmake", "--build", "."
      system "cmake", "--install", "."
    end
  end

  test do
    system "echo"
  end
end
