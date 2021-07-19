class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator.git",
    tag:      "v12.0.0",
    revision: "67d3e271a28287b2c92ecef2f5e98c49134e5946"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/spirv-llvm-translator-12.0.0"
    sha256 cellar: :any, big_sur: "b1e73d395f58b34b1abc4606d158fc2ba06151961398f18076fab9eb03d85009"
  end

  depends_on "cmake" => :build

  depends_on "llvm-core"

  def install
    cmake_args = std_cmake_args + %w[
      -D BUILD_SHARED_LIBS=ON
      -D CMAKE_CXX_STANDARD=17
      -D LLVM_BUILD_TOOLS=ON

      -S .
      -B build
    ]

    system "cmake", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "echo"
  end
end
