class BoostDynamicBitset < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/dynamic_bitset/"
  url "https://github.com/boostorg/dynamic_bitset.git",
    tag:      "boost-1.77.0",
    revision: "11d85403b905e8a1b485590dd170fef90d4bd045"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
