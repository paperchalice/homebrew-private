class BoostConvert < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/convert/"
  url "https://github.com/boostorg/convert.git",
    tag:      "boost-1.77.0",
    revision: "d5f7347d309d222d10e7a204ddd086e7d6c64b21"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
