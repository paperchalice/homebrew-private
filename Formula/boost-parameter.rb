class BoostParameter < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/parameter/"
  url "https://github.com/boostorg/parameter.git",
    tag:      "boost-1.77.0",
    revision: "94bfc0544a5c4b959d018814f25c54e796020578"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
