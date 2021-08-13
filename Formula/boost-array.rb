class BoostArray < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/array/"
  url "https://github.com/boostorg/array.git",
    tag:      "boost-1.77.0",
    revision: "63f83dc350b654172ad04cc719daea0f3643f83c"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
