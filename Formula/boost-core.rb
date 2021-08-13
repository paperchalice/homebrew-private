class BoostCore < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/core/"
  url "https://github.com/boostorg/core.git",
    tag:      "boost-1.77.0",
    revision: "f4b3d5dba6f86caaf96e45901655a954b2ff68b4"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
