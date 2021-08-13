class BoostConfig < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/config/"
  url "https://github.com/boostorg/config.git",
    tag:      "boost-1.77.0",
    revision: "088b79a0ca751932010f82d3f95457c8b483fb9b"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
