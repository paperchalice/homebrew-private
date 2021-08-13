class BoostMpi < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/mpi/"
  url "https://github.com/boostorg/mpi.git",
    tag:      "boost-1.77.0",
    revision: "ace80263884ee2af3cef2ab3644ff4b41d154e49"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
