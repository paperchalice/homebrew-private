class BoostFunctional < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/functional/"
  url "https://github.com/boostorg/functional.git",
    tag:      "boost-1.77.0",
    revision: "0c7697fc661cc0879dd55db63b3d44725a71b400"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
