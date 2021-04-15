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
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/clang-11.1.0_3"
    sha256 cellar: :any, big_sur: "b337a812317cd3baf863a7a3780116dcc64499fea778740cf5d23a192443a138"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python" => :build

  depends_on "llvm-core"

  depends_on "libc++" => :recommended

  resource "clang-tools-extra" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.0/clang-tools-extra-12.0.0.src.tar.xz"
    sha256 "ad41e0b527a65ade95c1ba690a5434cefaab4a2daa1be307caaa1e8541fe6d5c"
  end

  def install
    resource("clang-tools-extra").stage buildpath/"tools/extra"

    include_dirs = %W[
      #{MacOS.sdk_path}/usr/include
      #{HOMEBREW_PREFIX}/include
    ].join ":"

    # use ld because atom based lld is work in progress
    # -DCLANG_DEFAULT_LINKER=lld
    config_trick = '"+std::string(std::getenv("HOME"))+"/.local/etc/clang'
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_CXX_STANDARD=17

      -DCMAKE_EXE_LINKER_FLAGS=-L/usr/lib
      -DCMAKE_SHARED_LINKER_FLAGS=-L/usr/lib

      -DC_INCLUDE_DIRS=#{include_dirs}
      -DCLANG_DEFAULT_STD_C=c17
      -DCLANG_DEFAULT_STD_CXX=cxx17
      -DCLANG_DEFAULT_CXX_STDLIB=libc++
      -DCLANG_DEFAULT_RTLIB=compiler-rt
      -DCLANG_DEFAULT_UNWINDLIB=libunwind
      -DCLANG_CONFIG_FILE_SYSTEM_DIR=#{etc}/clang
      -DCLANG_CONFIG_FILE_USER_DIR=#{config_trick}
      -DCLANG_LINK_CLANG_DYLIB=OFF

      -DLLVM_EXTERNAL_CLANG_TOOLS_EXTRA_SOURCE_DIR=#{buildpath/"tools/extra"}

      -DDEFAULT_SYSROOT=#{MacOS.sdk_path}
    ]

    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *(std_cmake_args + args)
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
