class BoostFusion < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/fusion/"
  url "https://github.com/boostorg/fusion.git",
    tag:      "boost-1.77.0",
    revision: "500e4c120ff2f2414ec225a2a42eb1a665c79956"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
