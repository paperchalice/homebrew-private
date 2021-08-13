class BoostRange < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/range/"
  url "https://github.com/boostorg/range.git",
    tag:      "boost-1.77.0",
    revision: "88c6199aedf8bbb5a6a8966e534f9de99943cde2"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-range-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "cf19d70285dbfc2a5c28d8675a202a5cc14d8dcf5442bc05efe0d3ea4e7cbe75"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
