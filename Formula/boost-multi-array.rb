class BoostMultiArray < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/multi_array/"
  url "https://github.com/boostorg/multi_array.git",
    tag:      "boost-1.77.0",
    revision: "0c5348bef71b890c4bd06eff1ee5ebda69e7b27a"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
