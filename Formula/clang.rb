class Clang < Formula
  desc "C language family frontend for LLVM"
  homepage "https://clang.llvm.org"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.1.0/clang-11.1.0.src.tar.xz"
  sha256 "0a8288f065d1f57cb6d96da4d2965cbea32edc572aa972e466e954d17148558b"
  license "Apache-2.0" => { with: "LLVM-exception" }
  revision 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    url "https://llvm.org/"
    regex(/LLVM (\d+\.\d+\.\d+)/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/clang-11.1.0_1"
    sha256 cellar: :any, big_sur: "1803dc676abeca50b82408c8fd7794b5afb8bd0c7b06ace94e690874847708c5"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  depends_on "libc++"
  depends_on "llvm-core"

  resource "clang-tools-extra" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.1.0/clang-tools-extra-11.1.0.src.tar.xz"
    sha256 "76707c249de7a9cde3456b960c9a36ed9bbde8e3642c01f0ef61a43d61e0c1a2"
  end

  def install
    resource("clang-tools-extra").stage buildpath/"tools/extra"

    # Ensure use system libc++
    ENV["LDFLAGS"] = "-L/usr/lib"

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

      -DC_INCLUDE_DIRS=#{include_dirs}
      -DCLANG_DEFAULT_STD_C=c17
      -DCLANG_DEFAULT_STD_CXX=cxx17
      -DCLANG_DEFAULT_CXX_STDLIB=libc++
      -DCLANG_DEFAULT_RTLIB=compiler-rt
      -DCLANG_DEFAULT_UNWINDLIB=libunwind
      -DCLANG_CONFIG_FILE_SYSTEM_DIR=#{etc}/clang
      -DCLANG_CONFIG_FILE_USER_DIR=#{config_trick}
      -DDEFAULT_SYSROOT=#{MacOS.sdk_path}
      -DENABLE_EXPERIMENTAL_NEW_PASS_MANAGER=ON
    ]

    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *(std_cmake_args + args)
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    ENV.delete "CPATH"
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main(int argc, char *argv[])
      {
        printf("Hello World!\\n");
        return 0;
      }
    EOS
    system bin/"clang", "test.c", "-o", "test"
    assert_equal "Hello World!", shell_output("./test").chomp
  end
end
