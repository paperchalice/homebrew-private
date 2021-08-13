class BoostAssign < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/assign/"
  url "https://github.com/boostorg/assign.git",
    tag:      "boost-1.77.0",
    revision: "e764ac1ca08daa46b4609a99895fe4874b8dc53b"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
