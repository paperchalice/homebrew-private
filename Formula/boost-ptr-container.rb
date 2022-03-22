class BoostPtrContainer < Formula
  desc "Holding heap-allocated objects in an exception-safe manner"
  homepage "https://boost.org/libs/ptr_container/"
  url "https://github.com/boostorg/ptr_container.git",
    tag:      "boost-1.77.0",
    revision: "f1b0910503fb2e6329e9c852261fa18e325cb09b"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-ptr-container-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "1a9b29bab3692e30f42f0cf14a8c5ab7ffaa425b1bd3d0b3e1e2e7b78f23313d"
  end

  depends_on "boost-circular-buffer"
  depends_on "boost-serialization"
  depends_on "boost-unordered"

  def install
    prefix.install "include"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      int main() {
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++14", "test.cpp"
    system "./a.out"
  end
end
