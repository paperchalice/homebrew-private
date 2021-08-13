class BoostProto < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/proto/"
  url "https://github.com/boostorg/proto.git",
    tag:      "boost-1.77.0",
    revision: "7f924934689b940f3a72212ab0f714ec6fd6e34b"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
