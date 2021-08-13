class BoostHeap < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/heap/"
  url "https://github.com/boostorg/heap.git",
    tag:      "boost-1.77.0",
    revision: "dc2f19f8815cbe0654df61bfc5f31ad8b06fc883"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
