class BoostLexicalCast < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/lexical_cast/"
  url "https://github.com/boostorg/lexical_cast.git",
    tag:      "boost-1.77.0",
    revision: "934858fbdc86aead9831e579dc11575c579f577d"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
