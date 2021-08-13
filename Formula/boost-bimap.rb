class BoostBimap < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/bimap/"
  url "https://github.com/boostorg/bimap.git",
    tag:      "boost-1.77.0",
    revision: "85f0f02537d71794a415ef4b992629b2edebfbff"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
