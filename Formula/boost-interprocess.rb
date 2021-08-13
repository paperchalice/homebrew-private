class BoostInterprocess < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/interprocess/"
  url "https://github.com/boostorg/interprocess.git",
    tag:      "boost-1.77.0",
    revision: "7b2a37e614833f5fc7ab7d10df20aa11bc583bed"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
