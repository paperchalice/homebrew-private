class Lldb < Formula
  desc "Next generation, high-performance debugger"
  homepage "https://lldb.llvm.org/"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-12.0.1",
    revision: "fed41342a82f5a3a9201819a82bf7a48313e296b"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/lldb-12.0.1"
    rebuild 1
    sha256 cellar: :any, big_sur: "a461cdb286feee084b46a9b1006604ebd4c00f0de32e26d71d869901ea22f4d6"
  end

  depends_on "cmake" => :build
  depends_on "swig"  => :build

  depends_on "clang"
  depends_on "llvm-core"
  depends_on "lua"
  depends_on "python"
  depends_on "six"
  depends_on "xz"

  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    cmake_args = std_cmake_args + %W[
      -D CMAKE_CXX_STANDARD=17

      -D Clang_DIR=#{Formula["clang"].lib}/cmake/clang
      -D LLDB_BUILD_FRAMEWORK=OFF
      -D LLDB_FRAMEWORK_INSTALL_DIR=Frameworks
      -D LLDB_USE_SYSTEM_SIX=ON

      -S lldb
      -B build
    ]

    system "cmake", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"lldb", "--version"
  end
end
