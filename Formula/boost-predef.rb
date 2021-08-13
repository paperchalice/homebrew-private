class BoostPredef < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/predef/"
  url "https://github.com/boostorg/predef.git",
    tag:      "boost-1.77.0",
    revision: "e3a87328f415c61766838e1f5367885251b46e93"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
