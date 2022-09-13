class Clang < Formula
  desc "C language family frontend for LLVM"
  homepage "https://clang.llvm.org"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.0/llvm-project-15.0.0.src.tar.xz"
  sha256 "caaf8100365b6ebafc39fea803e902ca3ff38b4d5327b9927097808d32964db7"
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

  uses_from_macos "gzip" => :build
  uses_from_macos "libxml2"

  patch do
    url "https://github.com/paperchalice/homebrew-private/raw/main/Patch/clang.diff"
    sha256 "164ea8269c83d5f9dcdf1e2aef05ef7e4feaec0e822b54845e881a14ba2d7dda"
  end

  def install
    config_trick = '"s+std::getenv("HOME")+"/.local/etc/clang'
    py_ver = Language::Python.major_minor_version("python3")
    # CLANG_RESOURCE_DIR=../lib/clang/current
    cmake_args = std_cmake_args + %W[
      BUILD_SHARED_LIBS=ON
      CMAKE_CXX_STANDARD=17

      CLANG_CONFIG_FILE_SYSTEM_DIR=#{etc}/clang
      CLANG_CONFIG_FILE_USER_DIR=#{config_trick}
      CLANG_DEFAULT_STD_C=c17
      CLANG_DEFAULT_STD_CXX=cxx17
      CLANG_DEFAULT_CXX_STDLIB=libc++
      CLANG_DEFAULT_LINKER=lld
      CLANG_DEFAULT_RTLIB=compiler-rt
      CLANG_DEFAULT_UNWINDLIB=libunwind
      CLANG_LINK_CLANG_DYLIB=OFF
      CLANG_PYTHON_BINDINGS_VERSIONS=#{py_ver}
      DEFAULT_SYSROOT=#{MacOS.sdk_path}
      CLANGD_ENABLE_REMOTE=OFF

      LLVM_EXTERNAL_CLANG_TOOLS_EXTRA_SOURCE_DIR=#{buildpath}/clang-tools-extra
      LLVM_BUILD_DOCS=ON
      LLVM_INCLUDE_DOCS=ON
      LLVM_ENABLE_SPHINX=ON
      SPHINX_WARNINGS_AS_ERRORS=OFF
      SPHINX_OUTPUT_HTML=OFF
      SPHINX_OUTPUT_MAN=ON
    ].map { |o| "-D #{o}" } + %w[
      -S clang
      -B build
    ]

    system "cmake", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build", "--strip"
    lib.install "build/lib/ClangdXPC.framework"
    frameworks.install_symlink lib/"ClangdXPC.framework"
    system "gzip", *Dir[man1/"*"]
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
