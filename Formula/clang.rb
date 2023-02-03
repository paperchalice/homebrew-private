class Clang < Formula
  desc "C language family frontend for LLVM"
  homepage "https://clang.llvm.org"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.6/llvm-project-15.0.6.src.tar.xz"
  sha256 "9d53ad04dc60cb7b30e810faf64c5ab8157dadef46c8766f67f286238256ff92"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/clang-15.0.3"
    sha256 cellar: :any, monterey: "49723f9f6c781f13cde3b9d0720d28d2425a946724dcd06fa938aefc698e9959"
  end

  pour_bottle? only_if: :clt_installed

  depends_on "cmake"       => :build
  depends_on "python"      => :build
  depends_on "sphinx-doc"  => :build

  depends_on "llvm-core"

  uses_from_macos "gzip" => :build
  uses_from_macos "libxml2"

  patch do
    url "https://github.com/paperchalice/homebrew-private/raw/main/Patch/clang.diff"
    sha256 "ef5cd9aeb1aa261c6ae60fe82226dcdf9d924b2e8657e41ab0e75d2764ca3a8b"
  end

  patch :DATA

  def install
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
      CLANG_LINK_CLANG_DYLIB=OFF
      CLANG_PYTHON_BINDINGS_VERSIONS=#{py_ver}
      DEFAULT_SYSROOT=#{MacOS.sdk_path}
      CLANGD_ENABLE_REMOTE=OFF

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

__END__
diff --git a/clang/lib/Driver/Driver.cpp b/clang/lib/Driver/Driver.cpp
index 3f29afd..9dd12d5 100644
--- a/clang/lib/Driver/Driver.cpp
+++ b/clang/lib/Driver/Driver.cpp
@@ -219,7 +219,11 @@ Driver::Driver(StringRef ClangExecutable, StringRef TargetTriple,
   SystemConfigDir = CLANG_CONFIG_FILE_SYSTEM_DIR;
 #endif
 #if defined(CLANG_CONFIG_FILE_USER_DIR)
-  UserConfigDir = CLANG_CONFIG_FILE_USER_DIR;
+  {
+    SmallString<128> P;
+    llvm::sys::fs::expand_tilde(CLANG_CONFIG_FILE_USER_DIR, P);
+    UserConfigDir = static_cast<std::string>(P);
+  }
 #endif
 
   // Compute the path to the resource directory.
@@ -979,8 +983,8 @@ bool Driver::loadConfigFile() {
     }
     if (CLOptions->hasArg(options::OPT_config_user_dir_EQ)) {
       SmallString<128> CfgDir;
-      CfgDir.append(
-          CLOptions->getLastArgValue(options::OPT_config_user_dir_EQ));
+      llvm::sys::fs::expand_tilde(
+          CLOptions->getLastArgValue(options::OPT_config_user_dir_EQ), CfgDir);
       if (!CfgDir.empty()) {
         if (llvm::sys::fs::make_absolute(CfgDir).value() != 0)
           UserConfigDir.clear();
