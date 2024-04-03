class Flang < Formula
  desc "Fortran front end for LLVM"
  homepage "https://flang.llvm.org"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.2/llvm-project-18.1.2.src.tar.xz"
  sha256 "51073febd91d1f2c3b411d022695744bda322647e76e0b4eb1918229210c48d5"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/flang-14.0.0"
    sha256 cellar: :any, monterey: "0db27f8410f635e9208072dcb553e87ec8a0209a96ee2fa396a068387271e391"
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
    system "echo"
  end
end
