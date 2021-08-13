class BoostAssert < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/assert/"
  url "https://github.com/boostorg/assert.git",
    tag:      "boost-1.77.0",
    revision: "6aabfebae6d4acf996fe711de4e9b444ad88c17d"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
