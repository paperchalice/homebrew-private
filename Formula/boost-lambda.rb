class BoostLambda < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/lambda/"
  url "https://github.com/boostorg/lambda.git",
    tag:      "boost-1.77.0",
    revision: "4007043b545d3a834abaeaf141bb7dbd88c975cc"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
