class Clang < Formula
  desc "C language family frontend for LLVM"
  homepage "https://clang.llvm.org"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.2/llvm-project-17.0.2.src.tar.xz"
  sha256 "351562b14d42fcefcbf00cc1f327680a1062bbbf67a1e1ca6acb64c473b06394"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/clang-17.0.2"
    sha256 ventura: "421b268f8ae39592f3d04891c45ba4741413eed4d149230eba8f56205a219c0d"
  end

  pour_bottle? only_if: :clt_installed

  depends_on "cmake"       => :build
  depends_on "python"      => :build
  depends_on "sphinx-doc"  => :build

  depends_on "llvm-core"

  uses_from_macos "libxml2"

  patch :DATA

  def install
    py_ver = Language::Python.major_minor_version("python3")
    default_sysroot = MacOS.sdk_path.sub(/\d+/, "")
    cmake_args = std_cmake_args + %W[
      BUILD_SHARED_LIBS=ON

      CLANG_CONFIG_FILE_SYSTEM_DIR=#{etc}/clang
      CLANG_CONFIG_FILE_USER_DIR=~/.config/clang
      CLANG_DEFAULT_CXX_STDLIB=libc++
      CLANG_DEFAULT_LINKER=lld
      CLANG_DEFAULT_RTLIB=compiler-rt
      CLANG_DEFAULT_UNWINDLIB=libunwind
      CLANG_LINK_CLANG_DYLIB=OFF
      CLANG_PYTHON_BINDINGS_VERSIONS=#{py_ver}
      DEFAULT_SYSROOT=#{default_sysroot}

      LLVM_BUILD_DOCS=ON
      LLVM_INCLUDE_DOCS=ON
      LLVM_INCLUDE_TESTS=OFF
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
    elisp.install Dir[pkgshare/"*.el"]
    bash_completion.install pkgshare/"bash-autocomplete.sh" => "clang-completion.sh"

    (prefix/"etc/clang/macOS.options").write <<~EOS
      -Wall -Wextra
      -mmacosx-version-min=#{MacOS.version}.4
      -L #{HOMEBREW_PREFIX}/lib -I #{HOMEBREW_PREFIX}/include
      -F #{HOMEBREW_PREFIX}/Frameworks
    EOS
    (prefix/"etc/#{Hardware::CPU.arch}-apple-darwin#{MacOS.version}-clang.cfg").write <<~EOS
      -march=skylake
    EOS
    (prefix/"etc/clang/clang.cfg").write <<~EOS
      -std=c17
      @macOS.options
    EOS
    (prefix/"etc/clang/clang++.cfg").write <<~EOS
      -std=c++20
      @macOS.options
    EOS
    (prefix/"etc/clang/clang-cl.cfg").write <<~EOS
      /std:c++latest /Ehsc Zc:__cplusplus
    EOS
    (prefix/"etc/clang/clang-cpp.cfg").write <<~EOS
      -std=c17
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

__END__
--- a/clang/tools/clang-shlib/CMakeLists.txt
+++ b/clang/tools/clang-shlib/CMakeLists.txt
@@ -1,3 +1,4 @@
+return()
 # Building libclang-cpp.so fails if LLVM_ENABLE_PIC=Off
 if (NOT LLVM_ENABLE_PIC)
   return()