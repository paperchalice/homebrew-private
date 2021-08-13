class BoostAlgorithm < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/algorithm/"
  url "https://github.com/boostorg/algorithm.git",
    tag:      "boost-1.77.0",
    revision: "3b3bd8d3db43915c74d574ff36b4d945b6fc7917"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
