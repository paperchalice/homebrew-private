class BoostGil < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/gil/"
  url "https://github.com/boostorg/gil.git",
    tag:      "boost-1.77.0",
    revision: "e3e779cc69af4905e4910c06f7e9417c2563e362"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
