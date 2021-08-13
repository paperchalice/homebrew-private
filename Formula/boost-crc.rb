class BoostCrc < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/crc/"
  url "https://github.com/boostorg/crc.git",
    tag:      "boost-1.77.0",
    revision: "c80e31f78a248e33480ced76c4b03a0b71a5c4db"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
