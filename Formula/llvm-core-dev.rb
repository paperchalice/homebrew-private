class LlvmCoreDev < Formula
  desc "Next-gen compiler infrastructure"
  homepage "https://llvm.org/"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-12.0.1",
    revision: "fed41342a82f5a3a9201819a82bf7a48313e296b"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg-(\d+\.\d+\.\d+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/llvm-core-dev-12.0.1"
    rebuild 1
    sha256 cellar: :any, big_sur: "56a84b81046a965035578c825da0ffba4c197af27365eadfb0979cf8cfcbc53f"
  end

  depends_on "cmake"  => [:build, :test]
  depends_on "python" => :build

  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    inreplace "llvm/lib/Support/Unix/Path.inc", /(?<=return )link_path/, "exe_path"

    args = std_cmake_args + %w[
      -D CMAKE_CXX_STANDARD=17

      -D LLVM_ENABLE_PIC=OFF
      -D LLVM_ENABLE_SHARED_LIBS=OFF
      -D LLVM_ENABLE_EH=ON
      -D LLVM_ENABLE_FFI=ON
      -D LLVM_ENABLE_LIBCXX=ON
      -D LLVM_ENABLE_LTO=Thin
      -D LLVM_ENABLE_MODULES=ON
      -D LLVM_ENABLE_PROJECTS=mlir
      -D LLVM_ENABLE_RTTI=ON
      -D LLVM_INCLUDE_DOCS=OFF
      -D LLVM_INCLUDE_TESTS=OFF
      -D LLVM_INSTALL_UTILS=ON
      -D LLVM_OPTIMIZED_TABLEGEN=ON
      -D LLVM_CREATE_XCODE_TOOLCHAIN=OFF

      -S llvm
      -B build
    ]

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build", "--strip"

    site_package = Language::Python.site_packages("python3")
    (prefix/site_package).install "llvm/bindings/python/llvm"
    elisp.install Dir["llvm/utils/emacs/*.el"]
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION #{Formula["cmake"].version})
      project(test VERSION 1.0.0 LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

      find_package(LLVM REQUIRED CONFIG)

      # LLVM is normally built without RTTI. Be consistent with that.
      if(NOT LLVM_ENABLE_RTTI)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-rtti")
      endif()

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

    ENV.delete "CPATH"
    system "cmake", "-S", "."
    system "cmake", "--build", "."
    system "./test"
  end
end
