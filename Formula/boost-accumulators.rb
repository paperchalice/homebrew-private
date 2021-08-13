class BoostAccumulators < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/accumulators/"
  url "https://github.com/boostorg/accumulators.git",
    tag:      "boost-1.77.0",
    revision: "14c13370602fe86d134a948943958cab0921ce9c"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
