class BoostAsio < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/asio/"
  url "https://github.com/boostorg/asio.git",
    tag:      "boost-1.77.0",
    revision: "71431fcedeaf04be372c9d2c357be164c2742c43"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
