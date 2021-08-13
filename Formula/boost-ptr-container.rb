class BoostPtrContainer < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/ptr_container/"
  url "https://github.com/boostorg/ptr_container.git",
    tag:      "boost-1.77.0",
    revision: "f1b0910503fb2e6329e9c852261fa18e325cb09b"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
