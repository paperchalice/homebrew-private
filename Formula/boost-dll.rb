class BoostDll < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/dll/"
  url "https://github.com/boostorg/dll.git",
    tag:      "boost-1.77.0",
    revision: "ac134827f348b33dcdc3814b42cff57c2e792aad"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
