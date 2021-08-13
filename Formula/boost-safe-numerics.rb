class BoostSafeNumerics < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/safe_numerics/"
  url "https://github.com/boostorg/safe_numerics.git",
    tag:      "boost-1.77.0",
    revision: "d61e5ad30e96c0652b53ce83c7858c15d322cbbf"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
