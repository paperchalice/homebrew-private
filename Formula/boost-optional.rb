class BoostOptional < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/optional/"
  url "https://github.com/boostorg/optional.git",
    tag:      "boost-1.77.0",
    revision: "5a444eb84b67a5035e3577476234189c57ca55c1"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
