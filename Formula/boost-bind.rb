class BoostBind < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/bind/"
  url "https://github.com/boostorg/bind.git",
    tag:      "boost-1.77.0",
    revision: "34a3ee580c88d623c6bc9fe91460ef414dabfbe6"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
