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

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/lldb-12.0.0"
    sha256 cellar: :any, big_sur: "68fb3162dd7af581c2d0bc779fdeac5347f6a2ef7ba3fd62f2c3b2236bd24ad1"
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
    args = std_cmake_args+ %w[
      -DCMAKE_CXX_STANDARD=17

      -DLLDB_BUILD_FRAMEWORK=ON

      -S .
      -B build
    ]

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "echo"
  end
end
