class BoostGeometry < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/geometry/"
  url "https://github.com/boostorg/geometry.git",
    tag:      "boost-1.77.0",
    revision: "e2a0b14491e6af904882602ce1c47a0d74ad05a2"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-geometry-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "5ad1eaf5e27b6454b97ed38257dd26028fc0a13edb621aae0d841a0b62de03bc"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end