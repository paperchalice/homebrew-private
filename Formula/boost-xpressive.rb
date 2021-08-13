class BoostXpressive < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/xpressive/"
  url "https://github.com/boostorg/xpressive.git",
    tag:      "boost-1.77.0",
    revision: "4679fbd23f962bfa78d44acf5fa48f6f790642c0"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
