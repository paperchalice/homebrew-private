class Lldb < Formula
  desc "Next generation, high-performance debugger"
  homepage "https://lldb.llvm.org/"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-13.0.0",
    revision: "d7b669b3a30345cfcdb2fde2af6f48aa4b94845d"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/lldb-13.0.0"
    sha256 cellar: :any, big_sur: "f4c3c74b04bee8311a5eeb3d96025e78893160191a9e3e2a904e2fbf8047ae98"
  end

  depends_on "cmake" => :build
  depends_on "swig"  => :build

  depends_on "clang"
  depends_on "llvm-core"
  depends_on "lua"
  depends_on "python"
  depends_on "six"
  depends_on "xz"

  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  patch :DATA

  def install
    cmake_args = std_cmake_args + %W[
      -D BUILD_SHARED_LIBS=OFF
      -D CMAKE_CXX_STANDARD=17

      -D Clang_DIR=#{Formula["clang"].lib}/cmake/clang
      -D LLDB_BUILD_FRAMEWORK=ON
      -D LLDB_FRAMEWORK_INSTALL_DIR=Frameworks
      -D LLDB_USE_SYSTEM_SIX=ON

      -S lldb
      -B build
    ]

    system "cmake", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    site_package = Language::Python.site_packages("python3")
    (prefix/site_package).install_symlink frameworks/"Resources/Python/lldb"
    %w[darwin-debug lldb-argdumper debugserver].each { |x| bin.install_symlink frameworks/"Resources"/x }
    rm_rf frameworks/"LLDB.framework/Resources/Clang/include"
    headers = Formula["clang"].lib/"clang/#{Formula["clang"].version}/include"
    ln_s headers.relative_path_from(frameworks/"LLDB.framework/Resources/Clang"),
      frameworks/"LLDB.framework/Resources/Clang"
  end

  test do
    system bin/"lldb", "--version"
  end
end

__END__
diff --git a/lldb/bindings/python/CMakeLists.txt b/lldb/bindings/python/CMakeLists.txt
index 9422ee0..ed79bef 100644
--- a/lldb/bindings/python/CMakeLists.txt
+++ b/lldb/bindings/python/CMakeLists.txt
@@ -175,9 +175,11 @@ function(finish_swig_python swig_target lldb_python_bindings_dir lldb_python_tar
   set(python_scripts_install_target "install-${python_scripts_target}")
   add_custom_target(${python_scripts_target})
   add_dependencies(${python_scripts_target} ${swig_target})
-  install(DIRECTORY ${lldb_python_target_dir}/../
-          DESTINATION ${LLDB_PYTHON_INSTALL_PATH}
-          COMPONENT ${python_scripts_target})
+  if(NOT LLDB_BUILD_FRAMEWORK)
+    install(DIRECTORY ${lldb_python_target_dir}/../
+            DESTINATION ${LLDB_PYTHON_INSTALL_PATH}
+            COMPONENT ${python_scripts_target})
+  endif()
   if (NOT LLVM_ENABLE_IDE)
     add_llvm_install_targets(${python_scripts_install_target}
                              COMPONENT ${python_scripts_target}
diff --git a/lldb/tools/driver/CMakeLists.txt b/lldb/tools/driver/CMakeLists.txt
index c31863b..167b840 100644
--- a/lldb/tools/driver/CMakeLists.txt
+++ b/lldb/tools/driver/CMakeLists.txt
@@ -44,5 +44,6 @@ if(LLDB_BUILD_FRAMEWORK)
       "@loader_path/../../../SharedFrameworks"
       "@loader_path/../../System/Library/PrivateFrameworks"
       "@loader_path/../../Library/PrivateFrameworks"
+      "@loader_path/../${LLDB_FRAMEWORK_INSTALL_DIR}"
   )
 endif()
diff --git a/lldb/tools/lldb-vscode/CMakeLists.txt b/lldb/tools/lldb-vscode/CMakeLists.txt
index 41c1f10..7dc3765 100644
--- a/lldb/tools/lldb-vscode/CMakeLists.txt
+++ b/lldb/tools/lldb-vscode/CMakeLists.txt
@@ -58,5 +58,6 @@ if(LLDB_BUILD_FRAMEWORK)
       "@loader_path/../../../SharedFrameworks"
       "@loader_path/../../System/Library/PrivateFrameworks"
       "@loader_path/../../Library/PrivateFrameworks"
+      "@loader_path/../${LLDB_FRAMEWORK_INSTALL_DIR}"
   )
 endif()

