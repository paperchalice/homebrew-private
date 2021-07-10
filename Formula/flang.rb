class Flang < Formula
  desc "Fortran front end for LLVM"
  homepage "http://flang.llvm.org"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-12.0.1",
    revision: "fed41342a82f5a3a9201819a82bf7a48313e296b"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/flang-12.0.0"
    sha256 cellar: :any, big_sur: "8bdf10eae21a502c4103df0079d6824fe79232576a1845122ad4ae832b87e018"
  end

  depends_on "cmake" => :build
  depends_on "gcc"   => :test

  depends_on "llvm-core"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    args = std_cmake_args + %w[
      -D BUILD_SHARED_LIBS=ON
      -D CMAKE_CXX_STANDARD=17
      -D CMAKE_EXE_LINKER_FLAGS=-L/usr/lib
      -D CMAKE_SHARED_LINKER_FLAGS=-L/usr/lib

      -D FLANG_BUILD_NEW_DRIVER=OFF
      -D FLANG_INCLUDE_TESTS=OFF
      -S flang
      -B build
    ]

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build", "--strip"
  end

  test do
    (testpath/"hello.f90").write <<~EOS
      program hello
      implicit none
      write(*,*) 'Hello world!'
      end program hello
    EOS
    system "flang", "hello.f90"
    assert_match "Hello world!", `./a.out`
  end
end
