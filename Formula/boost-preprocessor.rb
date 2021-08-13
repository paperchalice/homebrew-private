class BoostPreprocessor < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/preprocessor/"
  url "https://github.com/boostorg/preprocessor.git",
    tag:      "boost-1.77.0",
    revision: "d4e82d7d3f2e2adbe280966ac51ce8f9372f5a44"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
