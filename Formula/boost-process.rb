class BoostProcess < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/process/"
  url "https://github.com/boostorg/process.git",
    tag:      "boost-1.77.0",
    revision: "b2a96a3e139ae42ea2bcb80cc58f108494a995c5"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
