class BoostCircularBuffer < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/circular_buffer/"
  url "https://github.com/boostorg/circular_buffer.git",
    tag:      "boost-1.77.0",
    revision: "d4fbf446b903fb6651b56bbd5931a9b902ef962c"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
