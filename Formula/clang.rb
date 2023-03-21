class Clang < Formula
  desc "C language family frontend for LLVM"
  homepage "https://clang.llvm.org"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.0/llvm-project-16.0.0.src.tar.xz"
  sha256 "9a56d906a2c81f16f06efc493a646d497c53c2f4f28f0cb1f3c8da7f74350254"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/clang-15.0.6"
    sha256 cellar: :any, monterey: "aa7d795d75bdbd95d33d1270a39b215272870095c5ef27b55846ae9654368ef2"
  end

  pour_bottle? only_if: :clt_installed

  depends_on "cmake"       => :build
  depends_on "python"      => :build
  depends_on "sphinx-doc"  => :build

  depends_on "llvm-core"

  uses_from_macos "libxml2"

  patch do
    url "https://github.com/paperchalice/homebrew-private/raw/main/Patch/clang.diff"
    sha256 "c9dded641e078a22695d565e57084beeee925ec48a5e09b826b1cf4eb0ef0f9f"
  end

  def install
    py_ver = Language::Python.major_minor_version("python3")
    default_sysroot = MacOS.sdk_path.sub(/\d+/, "")
    cmake_args = std_cmake_args + %W[
      BUILD_SHARED_LIBS=ON
      CMAKE_CXX_STANDARD=17

      CLANG_CONFIG_FILE_SYSTEM_DIR=#{etc}/clang
      CLANG_CONFIG_FILE_USER_DIR=~/.config/clang
      CLANG_DEFAULT_CXX_STDLIB=libc++
      CLANG_DEFAULT_LINKER=lld
      CLANG_DEFAULT_RTLIB=compiler-rt
      CLANG_DEFAULT_UNWINDLIB=libunwind
      CLANG_LINK_CLANG_DYLIB=OFF
      CLANG_PYTHON_BINDINGS_VERSIONS=#{py_ver}
      DEFAULT_SYSROOT=#{default_sysroot}
      GCC_INSTALL_PREFIX=#{HOMEBREW_PREFIX}

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
    system "cmake", "--build", "build"
    system "cmake", "--install", "build", "--strip"
    Utils::Gzip.compress(*Dir[man1/"*"])

    (prefix/"etc/clang/macOS.options").write <<~EOS
      -Wall -Wextra
      -L #{HOMEBREW_PREFIX}/lib -I #{HOMEBREW_PREFIX}/include
      -F #{HOMEBREW_PREFIX}/Frameworks
    EOS
    (prefix/"etc/clang/clang.cfg").write <<~EOS
      -std=c17
      @macOS.options
    EOS
    (prefix/"etc/clang/clang++.cfg").write <<~EOS
      -std=c++20
      @macOS.options
    EOS
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
