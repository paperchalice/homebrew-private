class BoostForeach < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/foreach/"
  url "https://github.com/boostorg/foreach.git",
    tag:      "boost-1.77.0",
    revision: "cc2f75ae30492b9de69b3b692f5c59afcb7dea5e"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
