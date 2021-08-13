class BoostCompatibility < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/compatibility/"
  url "https://github.com/boostorg/compatibility.git",
    tag:      "boost-1.77.0",
    revision: "47ce71af6b018764c9ba74c0bfcb4f3151b81aa7"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
