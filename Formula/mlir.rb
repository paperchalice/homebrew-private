class Mlir < Formula
  desc "Multi-Level Intermediate Representation"
  homepage "https://mlir.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.0/llvm-project-12.0.0.src.tar.xz"
  sha256 "9ed1688943a4402d7c904cc4515798cdb20080066efa010fe7e1f2551b423628"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    url "https://llvm.org/"
    regex(/LLVM (\d+\.\d+\.\d+)/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/mlir-11.1.0"
    sha256 cellar: :any, big_sur: "dffee6f243e14166849563ce14075e2bb13a307c333d7aad1029a49d8973ba4c"
  end

  depends_on "cmake" => [:build, :test]
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

      mkdir "build" do
        system "cmake", "-G", "Ninja", "..", *(std_cmake_args + args)
        system "cmake", "--build", "."
        system "cmake", "--install", "."
      end
    end
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION #{Formula["cmake"].version})
      project(standalone-dialect LANGUAGES CXX C)

      set(CMAKE_BUILD_WITH_INSTALL_NAME_DIR ON)

      set(CMAKE_CXX_STANDARD 14 CACHE STRING "C++ standard to conform to")

      find_package(MLIR REQUIRED CONFIG)

      message(STATUS "Using MLIRConfig.cmake in: ${MLIR_DIR}")
      message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

      set(LLVM_RUNTIME_OUTPUT_INTDIR ${CMAKE_BINARY_DIR}/bin)
      set(LLVM_LIBRARY_OUTPUT_INTDIR ${CMAKE_BINARY_DIR}/lib)
      set(MLIR_BINARY_DIR ${CMAKE_BINARY_DIR})

      list(APPEND CMAKE_MODULE_PATH "${MLIR_CMAKE_DIR}")
      list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
      include(TableGen)
      include(AddLLVM)
      include(AddMLIR)
      include(HandleLLVMOptions)

      include_directories(${LLVM_INCLUDE_DIRS})
      include_directories(${MLIR_INCLUDE_DIRS})
      link_directories(${LLVM_BUILD_LIBRARY_DIR})
      add_definitions(${LLVM_DEFINITIONS})

      set(LLVM_LINK_COMPONENTS
        Support
      )

      get_property(dialect_libs GLOBAL PROPERTY MLIR_DIALECT_LIBS)
      get_property(translation_libs GLOBAL PROPERTY MLIR_TRANSLATION_LIBS)

      add_llvm_executable(standalone-translate
        standalone-translate.cpp
        )
      llvm_update_compile_flags(standalone-translate)
      target_link_libraries(standalone-translate
        PRIVATE
        ${dialect_libs}
        ${translation_libs}
        MLIRIR
        MLIRParser
        MLIRPass
        MLIRSPIRV
        MLIRTranslation
        MLIRSupport
        )
    EOS

    (testpath/"standalone-translate.cpp").write <<~EOS
      #include "mlir/InitAllTranslations.h"
      #include "mlir/Support/LogicalResult.h"
      #include "mlir/Translation.h"

      int main(int argc, char **argv) {
        mlir::registerAllTranslations();
        return 0;
      }
    EOS

    system "cmake", "."
    system "make"
    system "./bin/standalone-translate"
  end
end
