class Lld < Formula
  desc "LLVM Linker"
  homepage "https://lld.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.0/lld-12.0.0.src.tar.xz"
  sha256 "2cb7d497f3ce33ce8a2c50ad26ec93a8c45f57268d4d96953cd0f25566f753fd"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :homepage
    regex(/LLVM (\d+\.\d+\.\d+)/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/lld-12.0.0"
    sha256 cellar: :any, big_sur: "a904e2ea619969cd895cf3a30d1954ded99414fcc16410c20c1b0005ab0f1027"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  depends_on "llvm-core"

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_CXX_STANDARD=17
    ]
    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *(std_cmake_args + args)
      system "cmake", "--build", "."
      system "cmake", "--install", "."
    end
  end

  test do
    system "echo"
  end
end
