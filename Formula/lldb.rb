class Lldb < Formula
  desc "Next generation, high-performance debugger"
  homepage "https://lldb.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.0/lldb-12.0.0.src.tar.xz"
  sha256 "14bcc0f55644df1a50ae9830e1f1751a7b3f633fb8605ee50e685a3db0c705ed"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url "https://llvm.org/"
    regex(/LLVM (\d+\.\d+\.\d+)/i)
  end

  depends_on "cmake" => :build

  depends_on "clang"
  depends_on "llvm-core"
  depends_on "lua"
  depends_on "python"

  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    args = std_cmake_args.reject { |s| s["CMAKE_BUILD_TYPE"] } + %w[
      -DCMAKE_BUILD_TYPE=MinSizeRel
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_EXE_LINKER_FLAGS=-L/usr/lib
      -DCMAKE_SHARED_LINKER_FLAGS=-L/usr/lib

      -DLLDB_BUILD_FRAMEWORK=ON
    ]
    mkdir "build" do
      system "cmake", "..", *(std_cmake_args + args)
      system "cmake", "--build", "."
      system "cmake", "--install", "."
    end
  end

  test do
    system "echo"
  end
end
