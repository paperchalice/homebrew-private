class BoostAny < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/any/"
  url "https://github.com/boostorg/any.git",
    tag:      "boost-1.77.0",
    revision: "ab9349aaa419b9ea53b5bc5cbe633690b376b8f5"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
