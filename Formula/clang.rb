class Clang < Formula
  desc "C language family frontend for LLVM"
  homepage "https://clang.llvm.org"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.0/clang-12.0.0.src.tar.xz"
  sha256 "e26e452e91d4542da3ebbf404f024d3e1cbf103f4cd110c26bf0a19621cca9ed"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    url "https://llvm.org/"
    regex(/LLVM (\d+\.\d+\.\d+)/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/clang-12.0.0"
    sha256 cellar: :any, big_sur: "9b539bd5a10175426da848c4bc4faa150b552b41f7ef9c4c772999bfb2ddf833"
  end

  depends_on "cmake" => :build
  depends_on "python" => :build

  depends_on "compiler-rt"
  depends_on "llvm-core"

  resource "clang-tools-extra" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.0/clang-tools-extra-12.0.0.src.tar.xz"
    sha256 "ad41e0b527a65ade95c1ba690a5434cefaab4a2daa1be307caaa1e8541fe6d5c"
  end

  def install
    resource("clang-tools-extra").stage buildpath/"tools/extra"
    inreplace "tools/extra/clangd/quality/CompletionModel.cmake",
      "../clang-tools-extra", "tools/extra"

    include_dirs = %W[
      #{MacOS.sdk_path}/usr/include
      #{HOMEBREW_PREFIX}/include
    ].join ":"

    # use ld because atom based lld is work in progress
    # -DCLANG_DEFAULT_LINKER=lld
    config_trick = '"+std::string(std::getenv("HOME"))+"/.local/etc/clang'
    args = std_cmake_args.reject { |s| s["CMAKE_BUILD_TYPE"] } + %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_BUILD_TYPE=MinSizeRel
      -DCMAKE_CXX_STANDARD=17

      -DC_INCLUDE_DIRS=#{include_dirs}
      -DCLANG_DEFAULT_STD_C=c17
      -DCLANG_DEFAULT_STD_CXX=cxx17
      -DCLANG_DEFAULT_CXX_STDLIB=libc++
      -DCLANG_DEFAULT_RTLIB=compiler-rt
      -DCLANG_DEFAULT_UNWINDLIB=libunwind
      -DCLANG_CONFIG_FILE_SYSTEM_DIR=#{etc}/clang
      -DCLANG_CONFIG_FILE_USER_DIR=#{config_trick}
      -DCLANG_LINK_CLANG_DYLIB=OFF

      -DDEFAULT_SYSROOT=#{MacOS.sdk_path}
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "cmake", "--build", "."
      system "cmake", "--install", "."
    end
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
