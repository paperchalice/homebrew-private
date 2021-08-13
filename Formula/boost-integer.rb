class BoostInteger < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/integer/"
  url "https://github.com/boostorg/integer.git",
    tag:      "boost-1.77.0",
    revision: "8fd622545f3e303f467526442a8765290e735778"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-integer-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "09612746b9ea2e92e1636f2dc79c435203fceff21c5e4706235b826edbaa8beb"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
