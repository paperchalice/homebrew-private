class BoostMpl < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/mpl/"
  url "https://github.com/boostorg/mpl.git",
    tag:      "boost-1.77.0",
    revision: "341748e4cb534f41fa3d0e34748f2771f5427123"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
