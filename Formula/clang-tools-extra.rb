class ClangToolsExtra < Formula
  desc "Extra clang tools"
  homepage "https://clang.llvm.org/extra/index.html"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.6/llvm-project-15.0.6.src.tar.xz"
  sha256 "9d53ad04dc60cb7b30e810faf64c5ab8157dadef46c8766f67f286238256ff92"
  license "Apache-2.0" => { with: "LLVM-exception" }

  depends_on "cmake"       => :build
  depends_on "python"      => :build
  depends_on "sphinx-doc"  => :build

  depends_on "clang"
  depends_on "grpc"

  uses_from_macos "gzip" => :build
  uses_from_macos "libxml2"

  def install
    (buildpath/"clang/tools").install "clang-tools-extra" => "extra"
    py_ver = Language::Python.major_minor_version("python3")
    # CLANG_RESOURCE_DIR=../lib/clang/current
    cmake_args = std_cmake_args + %W[
      BUILD_SHARED_LIBS=ON
      CMAKE_CXX_STANDARD=17
      CMAKE_STRIP=/usr/bin/strip

      CLANG_CONFIG_FILE_SYSTEM_DIR=#{etc}/clang
      CLANG_CONFIG_FILE_USER_DIR=~/.config/clang
      CLANG_DEFAULT_STD_C=c17
      CLANG_DEFAULT_STD_CXX=cxx17
      CLANG_DEFAULT_CXX_STDLIB=libc++
      CLANG_DEFAULT_LINKER=lld
      CLANG_DEFAULT_RTLIB=compiler-rt
      CLANG_DEFAULT_UNWINDLIB=libunwind
      CLANGD_ENABLE_REMOTE=ON
      CLANG_LINK_CLANG_DYLIB=OFF
      CLANG_PYTHON_BINDINGS_VERSIONS=#{py_ver}
      DEFAULT_SYSROOT=#{MacOS.sdk_path}
      CLANGD_ENABLE_REMOTE=OFF
      GRPC_INSTALL_PATH=#{HOMEBREW_PREFIX}

      LLVM_BUILD_DOCS=ON
      LLVM_INCLUDE_DOCS=ON
      LLVM_ENABLE_SPHINX=ON
      LLVM_INSTALL_UTILS=ON=ON
      SPHINX_WARNINGS_AS_ERRORS=OFF
      SPHINX_OUTPUT_HTML=OFF
      SPHINX_OUTPUT_MAN=ON
    ].map { |o| "-D #{o}" } + %w[
      -S clang
      -B build
    ]

    system "cmake", *cmake_args
    system "cmake", "--build", "build/tools/extra"
    system "cmake", "--install", "build/tools/extra", "--strip"
    lib.install "build/lib/ClangdXPC.framework"
    frameworks.install_symlink lib/"ClangdXPC.framework"
    system "gzip", *Dir[man1/"*"]
  end

  test do
    system "echo"
  end
end
