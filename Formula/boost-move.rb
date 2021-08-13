class BoostMove < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/move/"
  url "https://github.com/boostorg/move.git",
    tag:      "boost-1.77.0",
    revision: "6ab49a8d82909ffa6675325832f3e5f45f1bbb51"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
