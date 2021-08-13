class BoostHana < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/hana/"
  url "https://github.com/boostorg/hana.git",
    tag:      "boost-1.77.0",
    revision: "5c28aad03b6e157452d8623802d70dc95a7b57b6"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
