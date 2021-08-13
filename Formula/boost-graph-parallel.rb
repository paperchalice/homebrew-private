class BoostGraphParallel < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/graph_parallel/"
  url "https://github.com/boostorg/graph_parallel.git",
    tag:      "boost-1.77.0",
    revision: "476623e72b93faaf11888ad7c70a1bd301618858"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-graph-parallel-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "9e863f43b6a235d79c3385890f0b2a8cbb0a49fe6c4ad7c7eb98096eb443aade"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
