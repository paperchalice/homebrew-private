class Clang < Formula
  desc "C language family frontend for LLVM"
  homepage "https://clang.llvm.org"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-14.0.0",
    revision: "329fda39c507e8740978d10458451dcdb21563be"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/clang-14.0.0"
    sha256 cellar: :any, monterey: "75dd568c362c1866b21c00d762835a668c2837a42c8e93d1becff20cb3437f9d"
  end

  pour_bottle? only_if: :clt_installed

  depends_on "cmake"       => :build
  depends_on "python"      => :build
  depends_on "sphinx-doc"  => :build

  # TODO: depends_on "grpc"
  depends_on "llvm-core"

  uses_from_macos "libxml2"

  def install
    # avoid building libclang-cpp
    inreplace "clang/tools/clang-shlib/CMakeLists.txt", "LLVM_ENABLE_PIC", "OFF"

    # add `-L /usr/local/lib`
    inreplace "clang/lib/Driver/ToolChains/Darwin.cpp",
      "Args.AddAllArgs(CmdArgs, options::OPT_L);",
      (%Q{CmdArgs.push_back("-L#{HOMEBREW_PREFIX}/lib");\n} + "Args.AddAllArgs(CmdArgs, options::OPT_L);")

    inreplace "clang/lib/Driver/ToolChains/Clang.cpp",
      "// Parse additional include paths from environment variables.",
      "CmdArgs.push_back(\"-F#{HOMEBREW_PREFIX}/Frameworks\");"
    include_dirs = %W[
      #{MacOS.sdk_path}/usr/include
      #{HOMEBREW_PREFIX}/include
    ].join ":"

    config_trick = '"+std::string(std::getenv("HOME"))+"/.local/etc/clang'
    py_ver = Language::Python.major_minor_version("python3")
    cmake_args = std_cmake_args + %W[
      -D BUILD_SHARED_LIBS=ON
      -D CMAKE_CXX_STANDARD=17

      -D C_INCLUDE_DIRS=#{include_dirs}
      -D CLANG_CONFIG_FILE_SYSTEM_DIR=#{etc}/clang
      -D CLANG_CONFIG_FILE_USER_DIR=#{config_trick}
      -D CLANG_DEFAULT_STD_C=c17
      -D CLANG_DEFAULT_STD_CXX=cxx17
      -D CLANG_DEFAULT_CXX_STDLIB=libc++
      -D CLANG_DEFAULT_LINKER=lld
      -D CLANG_DEFAULT_RTLIB=compiler-rt
      -D CLANG_DEFAULT_UNWINDLIB=libunwind
      -D CLANG_LINK_CLANG_DYLIB=OFF
      -D CLANG_PYTHON_BINDINGS_VERSIONS=#{py_ver}
      -D DEFAULT_SYSROOT=#{MacOS.sdk_path}
      -D CLANGD_ENABLE_REMOTE=OFF

      -D LLVM_EXTERNAL_CLANG_TOOLS_EXTRA_SOURCE_DIR=#{buildpath}/clang-tools-extra
      -D LLVM_BUILD_DOCS=ON
      -D LLVM_INCLUDE_DOCS=ON
      -D LLVM_ENABLE_SPHINX=ON
      -D SPHINX_WARNINGS_AS_ERRORS=OFF
      -D SPHINX_OUTPUT_HTML=OFF
      -D SPHINX_OUTPUT_MAN=ON

      -S clang
      -B build
    ]

    system "cmake", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build", "--strip"
    lib.install "build/lib/ClangdXPC.framework"
    frameworks.install_symlink lib/"ClangdXPC.framework"
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
