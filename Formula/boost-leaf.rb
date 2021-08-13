class BoostLeaf < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/leaf/"
  url "https://github.com/boostorg/leaf.git",
    tag:      "boost-1.77.0",
    revision: "f94d964d49f0babd73066be7b4d98bc28777c28e"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-leaf-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "5f4713f442a7fd408f1162a6fe592caac241f2cd3e860ded9c2506c0bc1d54b0"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
