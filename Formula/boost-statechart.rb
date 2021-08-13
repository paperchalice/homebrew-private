class BoostStatechart < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/statechart/"
  url "https://github.com/boostorg/statechart.git",
    tag:      "boost-1.77.0",
    revision: "586445b824c5cf0e7e6ce4ff2df620fda5d0f0d7"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-statechart-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "800a20acf0dbf4b7f07f23c365d1509b08361b49c5cd4c0276dc5d7a05fd96f8"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end