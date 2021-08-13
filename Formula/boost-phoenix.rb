class BoostPhoenix < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/phoenix/"
  url "https://github.com/boostorg/phoenix.git",
    tag:      "boost-1.77.0",
    revision: "15500aec2187ab59e51d05addab0fdba7e788dbb"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
