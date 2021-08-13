class BoostCompute < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/compute/"
  url "https://github.com/boostorg/compute.git",
    tag:      "boost-1.77.0",
    revision: "36c89134d4013b2e5e45bc55656a18bd6141995a"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
