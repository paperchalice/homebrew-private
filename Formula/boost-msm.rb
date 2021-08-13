class BoostMsm < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/msm/"
  url "https://github.com/boostorg/msm.git",
    tag:      "boost-1.77.0",
    revision: "03f58ead6d0ec23d52e5c7b382e2c98df1d943d5"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
