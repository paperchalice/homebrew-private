class LlvmCore < Formula
  desc "Next-gen compiler infrastructure"
  homepage "https://llvm.org/"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-14.0.6",
    revision: "f28c006a5895fc0e329fe15fead81e37457cb1d1"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg-(\d+\.\d+\.\d+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/llvm-core-14.0.6"
    rebuild 1
    sha256 cellar: :any, monterey: "754307b119e68ec90d6c0c9cd83c077330549896e0b66e9d6d3493f1e657ad32"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "go"         => :build
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

  patch do
    url "https://github.com/paperchalice/homebrew-private/raw/main/Patch/llvm-core.diff"
    sha256 "9d41cce817e76b29243c9c1d383b1be1f3170f8bb886d659a97316b83342cbf1"
  end

  def install
    inreplace "llvm/cmake/modules/AddOCaml.cmake", "${CMAKE_SHARED_LIBRARY_SUFFIX}", ".so"
    opamroot = buildpath/".opam"
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"
    system "opam", "init", "--no-setup", "--disable-sandboxing"
    system "opam", "install", "ctypes"
    ENV.append_path "PATH", opamroot/"default/bin"

    cmake_args = std_cmake_args + %W[
      BUILD_SHARED_LIBS=ON
      CMAKE_CXX_STANDARD=17

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
      SPHINX_WARNINGS_AS_ERRORS=OFF
      SPHINX_OUTPUT_HTML=OFF
      SPHINX_OUTPUT_MAN=ON
      LLVM_INSTALL_BINUTILS_SYMLINKS=ON
      LLVM_INSTALL_CCTOOLS_SYMLINKS=ON
      LLVM_INSTALL_UTILS=ON
      LLVM_OCAML_INSTALL_PATH=#{lib}/ocaml
      LLVM_OPTIMIZED_TABLEGEN=ON
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
    bin.install "build/bin/llvm-go"
    elisp.install Dir["llvm/utils/emacs/*.el"]
    # Install Vim plugins
    %w[ftdetect ftplugin indent syntax].each do |dir|
      (share/"vim/vimfiles"/dir).install Dir["llvm/utils/vim/#{dir}/*.vim"]
    end
    system "gzip", *Dir[man1/"*"]
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
