class BoostOptional < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/optional/"
  url "https://github.com/boostorg/optional.git",
    tag:      "boost-1.77.0",
    revision: "5a444eb84b67a5035e3577476234189c57ca55c1"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-optional-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "a90c4a9a146ecfedbdd0944631526b6c85c92d418feedf36247a9861f40cf605"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
