class BoostBeast < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/beast/"
  url "https://github.com/boostorg/beast.git",
    tag:      "boost-1.77.0",
    revision: "710cc53331f197f6f17e8c38454c09df68e43c03"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
