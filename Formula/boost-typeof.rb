class BoostTypeof < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/typeof/"
  url "https://github.com/boostorg/typeof.git",
    tag:      "boost-1.77.0",
    revision: "46c7a05f826fc020ee88210ea2a5cd9278b930ab"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
