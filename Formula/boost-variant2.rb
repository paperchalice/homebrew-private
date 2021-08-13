class BoostVariant2 < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/variant2/"
  url "https://github.com/boostorg/variant2.git",
    tag:      "boost-1.77.0",
    revision: "4153a535a0fa8eb4d18abc262fcf2ae834601261"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
