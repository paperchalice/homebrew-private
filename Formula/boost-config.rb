class BoostConfig < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/config/"
  url "https://github.com/boostorg/config.git",
    tag:      "boost-1.77.0",
    revision: "088b79a0ca751932010f82d3f95457c8b483fb9b"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-config-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "230e96f6c23e8dc50d71777703ba3b9ad9bfd984d0e24100156b1d9494c35886"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
