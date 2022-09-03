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

  patch :DATA

  def install
    inreplace "clang/tools/driver/driver.cpp", "CLANG_PREFIX", prefix
    config_trick = '"s+std::getenv("HOME")+"/.local/etc/clang'
    py_ver = Language::Python.major_minor_version("python3")
    cmake_args = std_cmake_args + %W[
      -D BUILD_SHARED_LIBS=ON
      -D CMAKE_CXX_STANDARD=17

      -D CLANG_CONFIG_FILE_SYSTEM_DIR=#{etc}/clang
      -D CLANG_CONFIG_FILE_USER_DIR=#{config_trick}
      -D CLANG_RESOURCE_DIR=../lib/clang/current
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

__END__
diff --git a/clang/lib/Driver/Driver.cpp b/clang/lib/Driver/Driver.cpp
index 554e6b8..0155ee5 100644
--- a/clang/lib/Driver/Driver.cpp
+++ b/clang/lib/Driver/Driver.cpp
@@ -215,6 +215,7 @@ Driver::Driver(StringRef ClangExecutable, StringRef TargetTriple,
     SysRoot = std::string(P);
   }
 
+  using namespace std::string_literals;
 #if defined(CLANG_CONFIG_FILE_SYSTEM_DIR)
   SystemConfigDir = CLANG_CONFIG_FILE_SYSTEM_DIR;
 #endif
diff --git a/clang/lib/Driver/ToolChains/Darwin.cpp b/clang/lib/Driver/ToolChains/Darwin.cpp
index b060a6a..c0be9c5 100644
--- a/clang/lib/Driver/ToolChains/Darwin.cpp
+++ b/clang/lib/Driver/ToolChains/Darwin.cpp
@@ -617,6 +617,7 @@ void darwin::Linker::ConstructJob(Compilation &C, const JobAction &JA,
   if (!Args.hasArg(options::OPT_nostdlib, options::OPT_nostartfiles))
     getMachOToolChain().addStartObjectFileArgs(Args, CmdArgs);
 
+  CmdArgs.push_back("-L/usr/local/lib");
   Args.AddAllArgs(CmdArgs, options::OPT_L);
 
   AddLinkerInputs(getToolChain(), Inputs, Args, CmdArgs, JA);
@@ -2320,6 +2321,7 @@ void DarwinClang::AddClangSystemIncludeArgs(const llvm::opt::ArgList &DriverArgs
       SmallString<128> P(Sysroot);
       llvm::sys::path::append(P, "usr", "local", "include");
       addSystemInclude(DriverArgs, CC1Args, P);
+      addSystemInclude(DriverArgs, CC1Args, "/usr/local/include");
   }
 
   // Add the Clang builtin headers (<resource>/include)
diff --git a/clang/lib/Lex/InitHeaderSearch.cpp b/clang/lib/Lex/InitHeaderSearch.cpp
index 0caa776..5f651bc 100644
--- a/clang/lib/Lex/InitHeaderSearch.cpp
+++ b/clang/lib/Lex/InitHeaderSearch.cpp
@@ -467,6 +467,7 @@ void InitHeaderSearch::AddDefaultIncludePaths(const LangOptions &Lang,
       else {
         AddPath("/System/Library/Frameworks", System, true);
         AddPath("/Library/Frameworks", System, true);
+        AddUnmappedPath("/usr/local/Frameworks", System, true, None);
       }
     }
     return;
diff --git a/clang/tools/clang-shlib/CMakeLists.txt b/clang/tools/clang-shlib/CMakeLists.txt
index de9daba..3d8e519 100644
--- a/clang/tools/clang-shlib/CMakeLists.txt
+++ b/clang/tools/clang-shlib/CMakeLists.txt
@@ -1,3 +1,4 @@
+return()
 # Building libclang-cpp.so fails if LLVM_ENABLE_PIC=Off
 if (NOT LLVM_ENABLE_PIC)
   return()
diff --git a/clang/tools/driver/driver.cpp b/clang/tools/driver/driver.cpp
index 34335a5..e4e4b65 100644
--- a/clang/tools/driver/driver.cpp
+++ b/clang/tools/driver/driver.cpp
@@ -68,7 +68,11 @@ std::string GetExecutablePath(const char *Argv0, bool CanonicalPrefixes) {
   // This just needs to be some symbol in the binary; C++ doesn't
   // allow taking the address of ::main however.
   void *P = (void*) (intptr_t) GetExecutablePath;
-  return llvm::sys::fs::getMainExecutable(Argv0, P);
+  StringRef ME{llvm::sys::fs::getMainExecutable(Argv0, P)};
+  if (ME.consume_front("CLANG_PREFIX")) {
+    return "/usr/local" + ME.str();
+  }
+  return ME.str();
 }
 
 static const char *GetStableCStr(std::set<std::string> &SavedStrings,
