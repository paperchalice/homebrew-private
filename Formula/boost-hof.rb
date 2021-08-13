class BoostHof < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/hof/"
  url "https://github.com/boostorg/hof.git",
    tag:      "boost-1.77.0",
    revision: "0cd9c34d658fb58484002bb81fb5aff2c0be5599"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-hof-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "763a2ba5d4ba2562b46754cee6b85b97fabeae5b4d33fb375f78873557fd8619"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
