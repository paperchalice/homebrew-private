class BoostPtrContainer < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/ptr_container/"
  url "https://github.com/boostorg/ptr_container.git",
    tag:      "boost-1.77.0",
    revision: "f1b0910503fb2e6329e9c852261fa18e325cb09b"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-ptr-container-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "1a9b29bab3692e30f42f0cf14a8c5ab7ffaa425b1bd3d0b3e1e2e7b78f23313d"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
