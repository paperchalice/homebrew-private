class Polly < Formula
  desc "High-level loop and data-locality optimizer"
  homepage "https://polly.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.0/polly-12.0.0.src.tar.xz"
  sha256 "0d9afc76b262f89d0fc6cb4f155ad25be5bf0554d14f96208ec81a51a44fb4c7"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url "https://llvm.org/"
    regex(/LLVM (\d+\.\d+\.\d+)/i)
  end

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/polly-12.0.0"
    sha256 cellar: :any, big_sur: "b796816b1ca1201dbbf7bb0f29727af022d414d34890a7635e9665639d4f111c"
  end

  depends_on "cmake" => :build

  depends_on "llvm-core"

  def install
    args = std_cmake_args+ %w[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_CXX_STANDARD=17
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "cmake", "--build", "."
      system "cmake", "--install", "."
    end
  end

  test do
    system "echo"
  end
end
