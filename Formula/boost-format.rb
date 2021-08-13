class BoostFormat < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/format/"
  url "https://github.com/boostorg/format.git",
    tag:      "boost-1.77.0",
    revision: "c1170a6d546b36f9399f3983fad0994e8f946d8f"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
