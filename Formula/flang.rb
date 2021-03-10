class Flang < Formula
  desc "Ground-up implementation of a Fortran front end"
  homepage "http://flang.llvm.org"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.1.0/flang-11.1.0.src.tar.xz"
  sha256 "7e29e3799fe6c8253c6300a226d3aab7514c07a295821df6eab33d2984eef348"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    url "https://llvm.org/"
    regex(/LLVM (\d+\.\d+\.\d+)/i)
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  depends_on "clang"
  depends_on "llvm-core"
  depends_on "mlir"

  def install
    mkdir "build" do
      args = %w[
        -DBUILD_SHARED_LIBS=ON
        -DFLANG_BUILD_NEW_DRIVER=ON
      ]
      system "cmake", "-G", "Ninja", "..", *(std_cmake_args + args)
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.f90").write <<~EOS
      PROGRAM test
        WRITE(*,'(A)') 'Hello World!'
      ENDPROGRAM
    EOS

    system bin/"flang", "test.f90", "-o", "test"
    assert_equal "Hello World!", shell_output("./test").chomp
  end
end
