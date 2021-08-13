class BoostSort < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/sort/"
  url "https://github.com/boostorg/sort.git",
    tag:      "boost-1.77.0",
    revision: "72a3ae870c59980dadd757f5f63e6be16ab61c1b"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
