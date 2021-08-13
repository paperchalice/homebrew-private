class BoostOutcome < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/outcome/"
  url "https://github.com/boostorg/outcome.git",
    tag:      "boost-1.77.0",
    revision: "e9439030d49c2d70391d8a74509dfcdbcea3881e"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
