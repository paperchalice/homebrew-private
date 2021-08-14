class BoostContract < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/contract/"
  url "https://github.com/boostorg/boost.git",
    tag:      "boost-1.77.0",
    revision: "9d3f9bcd7d416880d4631d7d39cceeb4e8f25da0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-contract-1.77.0"
    sha256 cellar: :any, big_sur: "973572d0a175473b4423ae87c2a762518a72bdc7844426f7a1cf07073e538cc4"
  end

  depends_on "boost-config" => :build

  def install
    system "./bootstrap.sh"
    system "./b2", "--with-contract", "cxxflags=-std=c++14", "stage"

    bc = Formula["boost-config"]
    Pathname.glob(bc.lib/"cmake/*").each { |c| rm_rf "stage/lib/cmake/#{c.basename}" }

    prefix.install "stage/lib"
    prefix.install "libs/contract/include"
  end

  test do
    system "echo"
  end
end