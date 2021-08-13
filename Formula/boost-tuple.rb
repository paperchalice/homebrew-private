class BoostTuple < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/tuple/"
  url "https://github.com/boostorg/tuple.git",
    tag:      "boost-1.77.0",
    revision: "ec4f3b23c21581656f6241903e723e7fde761993"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
