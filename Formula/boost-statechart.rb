class BoostStatechart < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/statechart/"
  url "https://github.com/boostorg/statechart.git",
    tag:      "boost-1.77.0",
    revision: "586445b824c5cf0e7e6ce4ff2df620fda5d0f0d7"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
