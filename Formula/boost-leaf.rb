class BoostLeaf < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/leaf/"
  url "https://github.com/boostorg/leaf.git",
    tag:      "boost-1.77.0",
    revision: "f94d964d49f0babd73066be7b4d98bc28777c28e"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
