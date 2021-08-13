class BoostHeap < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/heap/"
  url "https://github.com/boostorg/heap.git",
    tag:      "boost-1.77.0",
    revision: "dc2f19f8815cbe0654df61bfc5f31ad8b06fc883"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-heap-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "f95d43b7e3b8f89a372a9ca3b47216f37ed884fd2577cea785024c25aaacdc09"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
