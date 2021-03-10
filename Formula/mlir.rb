class Mlir < Formula
  desc "Multi-Level Intermediate Representation"
  homepage "https://mlir.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.1.0/llvm-project-11.1.0.src.tar.xz"
  sha256 "74d2529159fd118c3eac6f90107b5611bccc6f647fdea104024183e8d5e25831"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    url "https://llvm.org/"
    regex(/LLVM (\d+\.\d+\.\d+)/i)
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  depends_on "llvm-core"

  def install
    cd "mlir" do
      inreplace "CMakeLists.txt", "# MLIR project.", <<~EOS
        if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
          project(mlir LANGUAGES CXX C)
          cmake_minimum_required(VERSION #{Formula["cmake"].version})
          set(CMAKE_CXX_STANDARD 14 CACHE STRING "C++ standard to conform to")

          find_package(LLVM CONFIG REQUIRED)
          set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${LLVM_CMAKE_DIR})
          include(HandleLLVMOptions)
          include(AddLLVM)
          include(TableGen)

          include_directories(${LLVM_INCLUDE_DIRS})

          set(LLVM_MAIN_SRC_DIR ${CMAKE_SOURCE_DIR}/../llvm CACHE PATH
              "Path to LLVM source tree")
          set(UNITTEST_DIR ${LLVM_MAIN_SRC_DIR}/utils/unittest)
          if(EXISTS ${UNITTEST_DIR}/googletest/include/gtest/gtest.h)
            add_subdirectory(${UNITTEST_DIR} utils/unittest)
          endif()

          set(CMAKE_LIBRARY_OUTPUT_DIRECTORY
            "${CMAKE_CURRENT_BINARY_DIR}/lib${LLVM_LIBDIR_SUFFIX}")
          set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/bin")
        endif()
      EOS

      args = %w[
        -DBUILD_SHARED_LIBS=ON
      ]

      system "cmake", "-G", "Ninja", ".", *(std_cmake_args + args)
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system "echo"
  end
end
