class BoostScopeExit < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/scope_exit/"
  url "https://github.com/boostorg/scope_exit.git",
    tag:      "boost-1.77.0",
    revision: "60baaae454b2da887a31cf939e22015b6263c9e4"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
