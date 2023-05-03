class LlvmCore < Formula
  desc "Next-gen compiler infrastructure"
  homepage "https://llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.3/llvm-project-16.0.3.src.tar.xz"
  sha256 "3b12e35332e10cf650578ae18247b91b04926d5427e1a6ae9a51d170a47cfbb2"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg-(\d+\.\d+\.\d+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/llvm-core-16.0.3"
    sha256 ventura: "b5b56185190e8d5f70cfc21505fa024c949414dc38a0d192d306c6ff122ccb0e"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "ocaml"      => :build
  depends_on "opam"       => :build
  depends_on "python"     => :build
  depends_on "sphinx-doc" => :build

  depends_on "zstd"

  depends_on "libtensorflow" => :optional
  depends_on "z3"            => :optional

  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "cpp-httplib" do
    url "https://github.com/yhirose/cpp-httplib/archive/refs/tags/v0.11.1.tar.gz"
    sha256 "1ce2f0393ba779ec34885c5cd937141b4b5b730e2bc2efc34eb8554289c24d61"
  end

  patch do
    url "https://github.com/paperchalice/homebrew-private/raw/main/Patch/llvm-core.diff"
    sha256 "f57595945e7c7ae9aa8c27bc80b0c1ab7c28502800b9d51c00cae0f2877cef61"
  end

  def install
    resource("cpp-httplib").stage do
      cpp_httplib_cmake_args = %W[
        -D CMAKE_INSTALL_PREFIX=#{buildpath}/cpp-httplib
        -D CMAKE_BUILD_TYPE=MinSizeRel
        -S .
        -B build
      ]
      system "cmake", *cpp_httplib_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    inreplace "llvm/cmake/modules/AddOCaml.cmake" do |s|
      s.gsub! "${CMAKE_SHARED_LIBRARY_SUFFIX}", ".so"
      s.gsub! "stdc++", "c++"
    end
    opamroot = buildpath/".opam"
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"
    system "opam", "init", "--no-setup", "--disable-sandboxing"
    system "opam", "install", "ctypes"
    ENV.append_path "PATH", opamroot/"default/bin"

    cmake_args = std_cmake_args + %W[
      BUILD_SHARED_LIBS=ON

      httplib_DIR=#{buildpath}/cpp-httplib/lib/cmake/httplib
      LLVM_ENABLE_CURL=ON
      LLVM_ENABLE_EH=ON
      LLVM_ENABLE_FFI=ON
      LLVM_ENABLE_HTTPLIB=ON
      LLVM_ENABLE_LIBCXX=ON
      LLVM_ENABLE_MODULES=OFF
      LLVM_ENABLE_OCAMLDOC=OFF
      LLVM_ENABLE_RTTI=ON
      LLVM_ENABLE_SPHINX=ON
      LLVM_ENABLE_ZSTD=ON
      LLVM_BUILD_DOCS=ON
      LLVM_INCLUDE_DOCS=ON
      LLVM_TOOL_LLVM_DRIVER_BUILD=OFF
      SPHINX_WARNINGS_AS_ERRORS=OFF
      SPHINX_OUTPUT_HTML=OFF
      SPHINX_OUTPUT_MAN=ON
      LLVM_INSTALL_BINUTILS_SYMLINKS=ON
      LLVM_INSTALL_CCTOOLS_SYMLINKS=ON
      LLVM_INSTALL_UTILS=ON
      LLVM_OCAML_INSTALL_PATH=#{lib}/ocaml
      LLVM_OPTIMIZED_TABLEGEN=ON
      LLVM_PREFER_STATIC_ZSTD=OFF
      LLVM_CREATE_XCODE_TOOLCHAIN=OFF
    ].map { |o| "-D #{o}" } + %w[
      -S llvm
      -B build
    ]
    cmake_args << "-D LLVM_ENABLE_Z3_SOLVER=ON" if build.with? "z3"
    cmake_args << "-D TENSORFLOW_C_LIB_PATH=#{Formula["libtensorflow"].prefix}" if build.with? "libtensorflow"

    system "cmake", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build", "--strip"

    site_package = Language::Python.site_packages("python3")
    (prefix/site_package).install "llvm/bindings/python/llvm"
    elisp.install Dir["llvm/utils/emacs/*.el"]
    # Install Vim plugins
    %w[ftdetect ftplugin indent syntax].each do |dir|
      (share/"vim/vimfiles"/dir).install Dir["llvm/utils/vim/#{dir}/*.vim"]
    end
    Utils::Gzip.compress(*Dir[man1/"*"])
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION #{Formula["cmake"].version})
      project(test VERSION 1.0.0 LANGUAGES C CXX)
      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

      find_package(LLVM REQUIRED CONFIG)

      # LLVM is normally built without RTTI. Be consistent with that.
      if(NOT LLVM_ENABLE_RTTI)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-rtti")
      endif()

      include_directories(SYSTEM ${LLVM_INCLUDE_DIRS})
      add_definitions(${LLVM_DEFINITIONS})

      add_executable(test
          main.cpp
      )
      llvm_map_components_to_libnames(llvm_libs Support Core IRReader)

      # Link against LLVM libraries
      target_link_libraries(test ${llvm_libs})
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <llvm/Support/Debug.h>
      #include <llvm/Support/raw_ostream.h>
      using namespace llvm;
      int main() {
        dbgs() << "test";
        return 0;
      }
    EOS

    system "cmake", "-S", ".", "--debug-find"
    system "cmake", "--build", "."
    system "./test"
  end
end
