class BoostPolyCollection < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/poly_collection/"
  url "https://github.com/boostorg/poly_collection.git",
    tag:      "boost-1.77.0",
    revision: "0b8bfc4cff012d0f23049fc5a0009ac4abadceb4"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
