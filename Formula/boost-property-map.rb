class BoostPropertyMap < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/property_map/"
  url "https://github.com/boostorg/property_map.git",
    tag:      "boost-1.77.0",
    revision: "6ed5bffff77d0ca5502d581ddc557208a3f43cd7"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-property-map-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "f0420a61fc2bfb9ab6fda268e0dfa55110bbbbee93b70171c1fd70d858f65368"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
