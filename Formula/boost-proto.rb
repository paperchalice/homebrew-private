class BoostProto < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/proto/"
  url "https://github.com/boostorg/proto.git",
    tag:      "boost-1.77.0",
    revision: "7f924934689b940f3a72212ab0f714ec6fd6e34b"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-proto-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "4c195b9813cab0cfb3551d5556d2670eebcd0861c82d232450eadade1a560d17"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
