class BoostVariant < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/variant/"
  url "https://github.com/boostorg/variant.git",
    tag:      "boost-1.77.0",
    revision: "89424892447ed252ebd4232ce6ebb664e58d71ba"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
