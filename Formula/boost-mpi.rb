class BoostMpi < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/mpi/"
  url "https://github.com/boostorg/mpi.git",
    tag:      "boost-1.77.0",
    revision: "ace80263884ee2af3cef2ab3644ff4b41d154e49"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-mpi-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "4ef57b11a0e4ccbdc42621e8428d95ed9f0ef032e31f80a52262f48b75d544ee"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
