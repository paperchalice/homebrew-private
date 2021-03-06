class BoostHeap < Formula
  desc "Implementation of priority queues"
  homepage "https://boost.org/libs/heap/"
  url "https://github.com/boostorg/heap.git",
    tag:      "boost-1.77.0",
    revision: "dc2f19f8815cbe0654df61bfc5f31ad8b06fc883"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-heap-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "f95d43b7e3b8f89a372a9ca3b47216f37ed884fd2577cea785024c25aaacdc09"
  end

  depends_on "boost-concept-check"
  depends_on "boost-intrusive"
  depends_on "boost-iterator"
  depends_on "boost-parameter"

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
