class BoostGraphParallel < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/graph_parallel/"
  url "https://github.com/boostorg/graph_parallel.git",
    tag:      "boost-1.77.0",
    revision: "476623e72b93faaf11888ad7c70a1bd301618858"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
