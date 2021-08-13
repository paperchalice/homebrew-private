class BoostDetail < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/detail/"
  url "https://github.com/boostorg/detail.git",
    tag:      "boost-1.77.0",
    revision: "a01fe6d57b906edf0400daebfb5ea88bb4582f44"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
