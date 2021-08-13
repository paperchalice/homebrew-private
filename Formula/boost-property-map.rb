class BoostPropertyMap < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/property_map/"
  url "https://github.com/boostorg/property_map.git",
    tag:      "boost-1.77.0",
    revision: "6ed5bffff77d0ca5502d581ddc557208a3f43cd7"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
