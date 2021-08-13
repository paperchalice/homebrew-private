class BoostInteger < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/integer/"
  url "https://github.com/boostorg/integer.git",
    tag:      "boost-1.77.0",
    revision: "8fd622545f3e303f467526442a8765290e735778"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
