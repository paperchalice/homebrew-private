class BoostRange < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/range/"
  url "https://github.com/boostorg/range.git",
    tag:      "boost-1.77.0",
    revision: "88c6199aedf8bbb5a6a8966e534f9de99943cde2"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
