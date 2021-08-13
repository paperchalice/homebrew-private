class BoostTypeIndex < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/type_index/"
  url "https://github.com/boostorg/type_index.git",
    tag:      "boost-1.77.0",
    revision: "a3c6a957eeaf1612eb34b013ec13e67d4c279a41"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
