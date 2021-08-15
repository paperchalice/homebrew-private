class BoostMp11 < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/mp11/"
  url "https://github.com/boostorg/mp11.git",
    tag:      "boost-1.77.0",
    revision: "9d43d1f69660617266c9168e6e121ab2b0ea2287"
  license "BSL-1.0"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
