class Clang < Formula
  desc "C language family frontend for LLVM"
  homepage "https://clang.llvm.org"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-13.0.0",
    revision: "d7b669b3a30345cfcdb2fde2af6f48aa4b94845d"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/clang-13.0.0"
    sha256 cellar: :any, big_sur: "7108a38a80dbe3db1d5e01a7f2aed413f1baa7bd1a8e02597a16ff2ddd79ad1e"
  end

  pour_bottle? only_if: :clt_installed

  depends_on "cmake"                             => :build
  depends_on "compiler-rt"                       => :build
  depends_on "lld"                               => :build
  depends_on "paperchalice/private/libunwind"    => :build
  depends_on "python"                            => :build
  depends_on "sphinx-doc"                        => :build

  depends_on "llvm-core"

  uses_from_macos "libxml2"

  def install
    cd "clang"
    ln_s buildpath/"clang-tools-extra", buildpath/"clang/tools/extra"

    # avoid building libclang-cpp
    inreplace "tools/CMakeLists.txt", "add_clang_subdirectory(clang-shlib)", ""

    # add `-L /usr/local/lib`
    inreplace "lib/Driver/ToolChains/Darwin.cpp",
      "Args.AddAllArgs(CmdArgs, options::OPT_L);",
      (%Q{CmdArgs.push_back("-L#{HOMEBREW_PREFIX}/lib");\n} + "Args.AddAllArgs(CmdArgs, options::OPT_L);")

    inreplace "lib/Driver/ToolChains/Clang.cpp",
      "// Parse additional include paths from environment variables.",
      "CmdArgs.push_back(\"-F#{HOMEBREW_PREFIX}/Frameworks\");"
    include_dirs = %W[
      #{MacOS.sdk_path}/usr/include
      #{HOMEBREW_PREFIX}/include
    ].join ":"

    cd "docs" do
      system "make", "-f", "Makefile.sphinx", "man"
      man1.install Pathname.glob("_build/man/*")
    end

    # use ld because atom based lld is work in progress
    # -DCLANG_DEFAULT_LINKER=lld
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["libc++"].lib
    config_trick = '"+std::string(std::getenv("HOME"))+"/.local/etc/clang'
    py_ver = Language::Python.major_minor_version("python3")
    args = std_cmake_args + %W[
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

      -S .
      -B build
    ]

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build", "--strip"
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
