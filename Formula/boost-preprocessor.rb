class BoostPreprocessor < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/preprocessor/"
  url "https://github.com/boostorg/preprocessor.git",
    tag:      "boost-1.77.0",
    revision: "d4e82d7d3f2e2adbe280966ac51ce8f9372f5a44"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-preprocessor-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "dc0a25d9dd2f4dc8db65f2c76096cd2b00ef191dc724e4fd55f6684e3b5ad014"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
