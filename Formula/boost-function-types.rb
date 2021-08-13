class BoostFunctionTypes < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/function_types/"
  url "https://github.com/boostorg/function_types.git",
    tag:      "boost-1.77.0",
    revision: "895335874d67987ada0d8bf6ca1725e70642ed49"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
