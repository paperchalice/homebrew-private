class BoostIcl < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/icl/"
  url "https://github.com/boostorg/icl.git",
    tag:      "boost-1.77.0",
    revision: "e6c06ddee1e2320f11c4ec5cd2661c4abe9bca53"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
