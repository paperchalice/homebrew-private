class BoostPfr < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/pfr/"
  url "https://github.com/boostorg/pfr.git",
    tag:      "boost-1.77.0",
    revision: "da12b52759ea52c3e2341690f208fea898643bbb"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
