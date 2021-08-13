class BoostThrowException < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/throw_exception/"
  url "https://github.com/boostorg/throw_exception.git",
    tag:      "boost-1.77.0",
    revision: "95e02ea52b8525ecf34dbf1e7fae34af09986b8a"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
