class Clang < Formula
  desc "C language family frontend for LLVM"
  homepage "https://clang.llvm.org"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.0/clang-12.0.0.src.tar.xz"
  sha256 "e26e452e91d4542da3ebbf404f024d3e1cbf103f4cd110c26bf0a19621cca9ed"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/clang-12.0.0"
    rebuild 2
    sha256 cellar: :any, big_sur: "af17f5014a97bdafba488718d4b3b32b47123fd8829aa8982ddff1ac4c53bf46"
  end

  depends_on "cmake"       => :build
  depends_on "compiler-rt" => :build
  depends_on "libc++"      => :build
  depends_on "python"      => :build
  depends_on "unwinder"    => :build

  depends_on "llvm-core"

  resource "clang-tools-extra" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.0/clang-tools-extra-12.0.0.src.tar.xz"
    sha256 "ad41e0b527a65ade95c1ba690a5434cefaab4a2daa1be307caaa1e8541fe6d5c"
  end

  def install
    resource("clang-tools-extra").stage buildpath/"tools/extra"
    # avoid building libclang-cpp
    inreplace "tools/CMakeLists.txt", "add_clang_subdirectory(clang-shlib)", ""
    inreplace "tools/extra/clangd/quality/CompletionModel.cmake",
      "../clang-tools-extra", "tools/extra"
    # add `-L /usr/local/lib`
    inreplace "lib/Driver/ToolChains/Darwin.cpp",
      "Args.AddAllArgs(CmdArgs, options::OPT_L);",
      (%Q{CmdArgs.push_back("-L#{HOMEBREW_PREFIX}/lib");\n} + "Args.AddAllArgs(CmdArgs, options::OPT_L);")

    include_dirs = %W[
      #{MacOS.sdk_path}/usr/include
      #{HOMEBREW_PREFIX}/include
      #{HOMEBREW_PREFIX}/Frameworks
    ].join ":"

    # use ld because atom based lld is work in progress
    # -DCLANG_DEFAULT_LINKER=lld
    config_trick = '"+std::string(std::getenv("HOME"))+"/.local/etc/clang'
    py_ver = Language::Python.major_minor_version("python3")
    args = std_cmake_args + %W[
      -D BUILD_SHARED_LIBS=ON
      -D CMAKE_CXX_STANDARD=17
      -D CMAKE_EXE_LINKER_FLAGS=-L/usr/lib
      -D CMAKE_SHARED_LINKER_FLAGS=-L/usr/lib

      -D C_INCLUDE_DIRS=#{include_dirs}
      -D CLANG_CONFIG_FILE_SYSTEM_DIR=#{etc}/clang
      -D CLANG_CONFIG_FILE_USER_DIR=#{config_trick}
      -D CLANG_DEFAULT_STD_C=c17
      -D CLANG_DEFAULT_STD_CXX=cxx17
      -D CLANG_DEFAULT_CXX_STDLIB=libc++
      -D CLANG_DEFAULT_RTLIB=compiler-rt
      -D CLANG_DEFAULT_UNWINDLIB=libunwind
      -D CLANG_LINK_CLANG_DYLIB=OFF
      -D CLANG_PYTHON_BINDINGS_VERSIONS=#{py_ver}

      -D DEFAULT_SYSROOT=#{MacOS.sdk_path}

      -S .
      -B build
    ]

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main(int argc, char *argv[])
      {
        printf("Hello World!\\n");
        return 0;
      }
    EOS
    system bin/"clang", "test.c"
    assert_match "Hello World!", shell_output("./a.out")
  end
end
