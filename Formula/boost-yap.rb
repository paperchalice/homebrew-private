class BoostYap < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/yap/"
  url "https://github.com/boostorg/yap.git",
    tag:      "boost-1.77.0",
    revision: "262624ac36652d1354e6b2ee38a79f2bc9a66cae"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
