class BoostVmd < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/vmd/"
  url "https://github.com/boostorg/vmd.git",
    tag:      "boost-1.77.0",
    revision: "34cad2c1a574d445812c7c2432d3a5a5c843b412"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
