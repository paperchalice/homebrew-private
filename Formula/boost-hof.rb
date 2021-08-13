class BoostHof < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/hof/"
  url "https://github.com/boostorg/hof.git",
    tag:      "boost-1.77.0",
    revision: "0cd9c34d658fb58484002bb81fb5aff2c0be5599"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
