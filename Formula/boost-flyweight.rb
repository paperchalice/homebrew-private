class BoostFlyweight < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/flyweight/"
  url "https://github.com/boostorg/flyweight.git",
    tag:      "boost-1.77.0",
    revision: "af4fd3e8eb532099cec51bb6f199029b65e7998d"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
