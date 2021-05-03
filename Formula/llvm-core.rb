class LlvmCore < Formula
  desc "Next-gen compiler infrastructure"
  homepage "https://llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.0/llvm-12.0.0.src.tar.xz"
  sha256 "49dc47c8697a1a0abd4ee51629a696d7bfe803662f2a7252a3b16fc75f3a8b50"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :homepage
    regex(/LLVM (\d+\.\d+\.\d+)/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/llvm-core-12.0.0"
    sha256 cellar: :any, big_sur: "349244ca092e3a447fc82a4f9afdd84b31fa5e334509d583782b782bb58c2f72"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "python" => :build
  depends_on "swig" => :build

  uses_from_macos "libedit"
  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    #-DLLVM_BUILD_LLVM_DYLIB=ON
    #-DLLVM_LINK_LLVM_DYLIB=ON
    args = std_cmake_args+ %W[
      -D BUILD_SHARED_LIBS=ON
      -D CMAKE_CXX_STANDARD=17
      -D DEFAULT_SYSROOT=#{MacOS.sdk_path}

      -D LLVM_BUILD_LLVM_DYLIB=OFF
      -D LLVM_LINK_LLVM_DYLIB=OFF
      -D LLVM_ENABLE_EH=ON
      -D LLVM_ENABLE_FFI=ON
      -D LLVM_ENABLE_LIBCXX=ON
      -D LLVM_ENABLE_MODULES=ON
      -D LLVM_ENABLE_RTTI=ON
      -D LLVM_INCLUDE_DOCS=OFF
      -D LLVM_INCLUDE_TESTS=OFF
      -D LLVM_INSTALL_UTILS=ON
      -D LLVM_ENABLE_Z3_SOLVER=OFF
      -D LLVM_OPTIMIZED_TABLEGEN=ON
      -D LLVM_USE_NEW_PM=ON
      -D LLVM_CREATE_XCODE_TOOLCHAIN=OFF

      -S .
      -B build
    ]

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION #{Formula["cmake"].version})
      project(test VERSION 1.0.0 LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

      find_package(LLVM REQUIRED CONFIG)

      include_directories(SYSTEM ${LLVM_INCLUDE_DIRS})
      add_definitions(${LLVM_DEFINITIONS})

      add_executable(test
          main.cpp
      )
      llvm_map_components_to_libnames(llvm_libs Support Core IRReader)

      # Link against LLVM libraries
      target_link_libraries(test ${llvm_libs})
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <llvm/Support/Debug.h>
      #include <llvm/Support/raw_ostream.h>
      using namespace llvm;
      int main() {
        dbgs() << "test";
        return 0;
      }
    EOS
    system "cmake", "."
    system "make"
    system "./test"
  end
end
