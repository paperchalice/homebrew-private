class Flang < Formula
  desc "Fortran front end for LLVM"
  homepage "https://flang.llvm.org"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.3/llvm-project-18.1.3.src.tar.xz"
  sha256 "2929f62d69dec0379e529eb632c40e15191e36f3bd58c2cb2df0413a0dc48651"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/flang-18.1.2"
    rebuild 1
    sha256 cellar: :any, ventura: "a23314ea8af9142d5085657050916714c560025920d359e13944935472b2dfe2"
  end

  depends_on "cmake"       => :build
  depends_on "sphinx-doc"  => :build

  depends_on "clang"
  depends_on "llvm-core"
  depends_on "mlir"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  resource "cpp-httplib" do
    url "https://github.com/yhirose/cpp-httplib/archive/refs/tags/v0.15.3.tar.gz"
    sha256 "2121bbf38871bb2aafb5f7f2b9b94705366170909f434428352187cb0216124e"
  end

  patch do
    url "https://github.com/llvm/llvm-project/commit/7d55a3ba92368be55b392c20d623fde6ac82d86d.patch?full_index=1"
    sha256 "e333769f9150482c357fcd45914b959543d29bfe86406f10f9c5d054bd269878"
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
      (prefix/"etc/clang/flang.cfg").write <<~EOS
        -std=f2018
      EOS
    end

    cmake_args = std_cmake_args + %W[
      -D BUILD_SHARED_LIBS=ON

      -D CLANG_DIR=#{Formula["clang"].lib}/cmake/clang
      -D httplib_DIR=#{buildpath}/cpp-httplib/lib/cmake/httplib
      -D LLVM_BUILD_DOCS=OFF
      -D LLVM_INCLUDE_DOCS=ON
      -D FLANG_INCLUDE_TESTS=OFF
      -D LLVM_ENABLE_SPHINX=ON
      -D MLIR_TABLEGEN_EXE=#{Formula["mlir"].bin}/mlir-tblgen
      -D SPHINX_WARNINGS_AS_ERRORS=OFF
      -D SPHINX_OUTPUT_HTML=OFF
      -D SPHINX_OUTPUT_MAN=ON

      -S flang
      -B build
    ]

    system "cmake", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build", "--strip"
    Utils::Gzip.compress(*Dir[man1/"*"])
  end

  test do
    (testpath/"test.f90").write <<~EOS
      program hello
        print *, 'Hello, World!'
      end program hello
    EOS
    system bin/"flang-new", "test.f90"
    assert_match "Hello, World!", shell_output("./a.out")
  end
end
