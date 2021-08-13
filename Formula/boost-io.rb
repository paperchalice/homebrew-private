class BoostIo < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/io/"
  url "https://github.com/boostorg/io.git",
    tag:      "boost-1.77.0",
    revision: "7392d7274c3743e605bf58076566c258617833ed"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
