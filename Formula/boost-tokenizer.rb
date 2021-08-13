class BoostTokenizer < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/tokenizer/"
  url "https://github.com/boostorg/tokenizer.git",
    tag:      "boost-1.77.0",
    revision: "f0857f042d96b5dd04ad5c2561f7006cddbdcde5"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
