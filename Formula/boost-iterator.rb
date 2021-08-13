class BoostIterator < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/iterator/"
  url "https://github.com/boostorg/iterator.git",
    tag:      "boost-1.77.0",
    revision: "72a7fb1b7372cf18df331e0ebbfb555f244c03fe"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
