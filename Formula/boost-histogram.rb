class BoostHistogram < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/histogram/"
  url "https://github.com/boostorg/histogram.git",
    tag:      "boost-1.77.0",
    revision: "90a58d03ee4a1eafb66ecfb642bb9344256cd17e"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-histogram-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "cb459900af8d55c9c12c5b63bf663df750c653403c0a2d98641106e2ed98e0a7"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
