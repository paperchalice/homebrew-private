class BoostSpirit < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/spirit/"
  url "https://github.com/boostorg/spirit.git",
    tag:      "boost-1.77.0",
    revision: "eeb2f2052f4ae7f77bca1bef24916c558832be83"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
