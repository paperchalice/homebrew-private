class FlangRt < Formula
  desc "Flang runtime library"
  homepage "https://flang.llvm.org"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.0/llvm-project-20.1.0.src.tar.xz"
  sha256 "4579051e3c255fb4bb795d54324f5a7f3ef79bd9181e44293d7ee9a7f62aad9a"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git"

  depends_on "cmake" => :build

  depends_on "llvm-core"

  def install
    cmake_args = std_cmake_args+ %W[
      -D LLVM_ENABLE_RUNTIMES=flang-rt

      -S runtimes
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
