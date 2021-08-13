class BoostUblas < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/ublas/"
  url "https://github.com/boostorg/ublas.git",
    tag:      "boost-1.77.0",
    revision: "f0e55caf310d5e01c7e9f2190b2422e113ddeedb"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
