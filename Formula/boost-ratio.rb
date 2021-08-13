class BoostRatio < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/ratio/"
  url "https://github.com/boostorg/ratio.git",
    tag:      "boost-1.77.0",
    revision: "00073b7d5896603b2036a334253dc9784285355c"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
