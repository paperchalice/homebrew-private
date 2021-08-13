class BoostVariant < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/variant/"
  url "https://github.com/boostorg/variant.git",
    tag:      "boost-1.77.0",
    revision: "89424892447ed252ebd4232ce6ebb664e58d71ba"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-variant-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "ec94e8180a54a5af97593ea121ecd7905fdd64136ed2eade77a331363a9fa13e"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
