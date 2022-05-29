class LlvmCore < Formula
  desc "Next-gen compiler infrastructure"
  homepage "https://llvm.org/"
  url "https://github.com/llvm/llvm-project.git",
    tag:      "llvmorg-14.0.4",
    revision: "29f1039a7285a5c3a9c353d054140bf2556d4c4d"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg-(\d+\.\d+\.\d+)$/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/llvm-core-14.0.0"
    sha256 cellar: :any, monterey: "7dae7a893ee3bed8daefc66517804777887fbac5a53bb4d920d4cf73bf7f50bd"
  end

  depends_on "cmake"      => [:build, :test]
  depends_on "python"     => :build
  depends_on "sphinx-doc" => :build

  depends_on "libtensorflow" => :optional
  depends_on "z3"            => :optional

  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    inreplace "llvm/lib/Support/Unix/Path.inc", /(?<=return )link_path/, "exe_path"

    cmake_args = std_cmake_args + %w[
      -D BUILD_SHARED_LIBS=ON
      -D CMAKE_CXX_STANDARD=17

      -D LLVM_ENABLE_CURL=ON
      -D LLVM_ENABLE_EH=ON
      -D LLVM_ENABLE_FFI=ON
      -D LLVM_ENABLE_LIBCXX=ON
      -D LLVM_ENABLE_MODULES=OFF
      -D LLVM_ENABLE_RTTI=ON
      -D LLVM_ENABLE_SPHINX=ON
      -D LLVM_BUILD_DOCS=ON
      -D LLVM_INCLUDE_DOCS=ON
      -D SPHINX_WARNINGS_AS_ERRORS=OFF
      -D SPHINX_OUTPUT_HTML=OFF
      -D SPHINX_OUTPUT_MAN=ON
      -D LLVM_INSTALL_BINUTILS_SYMLINKS=ON
      -D LLVM_INSTALL_CCTOOLS_SYMLINKS=ON
      -D LLVM_INSTALL_UTILS=ON
      -D LLVM_OPTIMIZED_TABLEGEN=ON
      -D LLVM_CREATE_XCODE_TOOLCHAIN=OFF

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
