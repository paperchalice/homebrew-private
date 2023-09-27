class Lldb < Formula
  desc "Next generation, high-performance debugger"
  homepage "https://lldb.llvm.org/"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-14.0.0",
    revision: "329fda39c507e8740978d10458451dcdb21563be"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/lldb-14.0.0"
    sha256 cellar: :any, monterey: "b244816aede2f3e78ca0fa05983180c5fee6b8c804bbc0172f66f7e09ecd2b4c"
  end

  depends_on "cmake"       => :build
  depends_on "sphinx-doc"  => :build
  depends_on "swig"        => :build

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

  def install
    %w[lldb-vscode driver].each do |t|
      inreplace "lldb/tools/#{t}/CMakeLists.txt", '"@', "#"
      inreplace "lldb/tools/#{t}/CMakeLists.txt", "INSTALL_RPATH", "INSTALL_RPATH \"#{rpath}\""
    end

    cmake_args = std_cmake_args + %W[
      -D BUILD_SHARED_LIBS=OFF
      -D CMAKE_CXX_STANDARD=17

      -D Clang_DIR=#{Formula["clang"].lib}/cmake/clang
      -D LLDB_BUILD_FRAMEWORK=ON
      -D LLDB_SKIP_DSYM=ON
      -D LLDB_FRAMEWORK_INSTALL_DIR=lib
      -D LLDB_USE_SYSTEM_SIX=ON

      -D LLVM_BUILD_DOCS=ON
      -D LLVM_INCLUDE_DOCS=ON
      -D LLVM_ENABLE_SPHINX=ON
      -D SPHINX_WARNINGS_AS_ERRORS=OFF
      -D SPHINX_OUTPUT_HTML=OFF
      -D SPHINX_OUTPUT_MAN=ON

      -S lldb
      -B build
    ]

    system "cmake", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    site_package = Language::Python.site_packages("python3")
    lldb_framework = lib/"LLDB.framework"
    frameworks.install_symlink lib/"LLDB.framework"
    clangf = Formula["clang"]
    (prefix/site_package).install_symlink lldb_framework/"Resources/Python/lldb"
    %w[darwin-debug lldb-argdumper debugserver].each { |x| bin.install_symlink lldb_framework/"Resources"/x }
    rm_rf lldb_framework/"Resources/Clang/include"
    headers = clangf.lib/"clang/#{clangf.version}/include"
    (lldb_framework/"Resources/Clang").install_symlink headers
  end

  test do
    system bin/"lldb", "--version"
  end
end
