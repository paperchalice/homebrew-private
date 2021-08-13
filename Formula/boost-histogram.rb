class BoostHistogram < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/histogram/"
  url "https://github.com/boostorg/histogram.git",
    tag:      "boost-1.77.0",
    revision: "90a58d03ee4a1eafb66ecfb642bb9344256cd17e"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
