class BoostUnordered < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/unordered/"
  url "https://github.com/boostorg/unordered.git",
    tag:      "boost-1.77.0",
    revision: "c494b3db58344aa60ac362887451776a1c5d56c8"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
