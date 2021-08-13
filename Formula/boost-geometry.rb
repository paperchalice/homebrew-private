class BoostGeometry < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/geometry/"
  url "https://github.com/boostorg/geometry.git",
    tag:      "boost-1.77.0",
    revision: "e2a0b14491e6af904882602ce1c47a0d74ad05a2"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
