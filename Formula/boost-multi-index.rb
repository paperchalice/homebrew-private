class BoostMultiIndex < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/multi_index/"
  url "https://github.com/boostorg/multi_index.git",
    tag:      "boost-1.77.0",
    revision: "2bbf21cfc9fd8a782aa445eec178dbc15986e761"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
