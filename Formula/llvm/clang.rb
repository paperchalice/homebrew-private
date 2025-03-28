class Clang < Formula
  desc "C language family frontend for LLVM"
  homepage "https://clang.llvm.org"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.0/llvm-project-20.1.0.src.tar.xz"
  sha256 "4579051e3c255fb4bb795d54324f5a7f3ef79bd9181e44293d7ee9a7f62aad9a"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/clang-20.1.0"
    rebuild 1
    sha256 ventura: "a5da446095cbdf193e5d1e79d927af327df73e60b093986db1efc4c3f527588b"
  end

  pour_bottle? only_if: :clt_installed

  depends_on "cmake"       => :build
  depends_on "python"      => :build
  depends_on "sphinx-doc"  => :build

  depends_on "llvm-core"

  uses_from_macos "libxml2"

  # cherrypick PR 131997
  patch :DATA

  def install
    inreplace "clang/tools/clang-shlib/CMakeLists.txt", "NOT LLVM_ENABLE_PIC", "TRUE"
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
      LLVM_BUILD_UTILS=ON
      LLVM_INSTALL_UTILS=ON
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
    (prefix/"etc/clang/#{Hardware::CPU.arch}-apple-darwin#{MacOS.version}-clang.cfg").write <<~EOS
      -march=skylake
    EOS
    (prefix/"etc/clang/clang.cfg").write <<~EOS
      -std=c23
      @macOS.options
    EOS
    (prefix/"etc/clang/clang++.cfg").write <<~EOS
      -std=c++23
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
diff --git a/clang/lib/Driver/Driver.cpp b/clang/lib/Driver/Driver.cpp
--- a/clang/lib/Driver/Driver.cpp
+++ b/clang/lib/Driver/Driver.cpp
@@ -95,8 +95,9 @@
 #include "llvm/Support/raw_ostream.h"
 #include "llvm/TargetParser/Host.h"
 #include "llvm/TargetParser/RISCVISAInfo.h"
 #include <cstdlib> // ::getenv
+#include <filesystem>
 #include <map>
 #include <memory>
 #include <optional>
 #include <set>
@@ -6432,10 +6433,12 @@
     return *P;
 
   SmallString<128> R2(ResourceDir);
   llvm::sys::path::append(R2, "..", "..", Name);
-  if (llvm::sys::fs::exists(Twine(R2)))
-    return std::string(R2);
+  std::string StrR2 = std::string(R2);
+  std::filesystem::path PR2 = std::filesystem::path(StrR2).lexically_normal();
+  if (llvm::sys::fs::exists(Twine(PR2.string())))
+    return PR2.string();
 
   return std::string(Name);
 }
 
