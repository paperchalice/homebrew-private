class BoostLambda < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/lambda/"
  url "https://github.com/boostorg/lambda.git",
    tag:      "boost-1.77.0",
    revision: "4007043b545d3a834abaeaf141bb7dbd88c975cc"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-lambda-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "25e8fb0d1f3091e0fd588e18b131d8246fd2dff7e984779c5a8a962952916ad6"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
