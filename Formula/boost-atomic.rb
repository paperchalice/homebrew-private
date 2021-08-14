class BoostAtomic < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/atomic/"
  url "https://github.com/boostorg/boost.git",
    tag:      "boost-1.77.0",
    revision: "9d3f9bcd7d416880d4631d7d39cceeb4e8f25da0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-atomic-1.77.0"
    rebuild 1
    sha256 cellar: :any, big_sur: "aefbaf7b076b7ac122fa968132fc508d1e3bb4d9d5dfcb8cd45cfbdda72fcfff"
  end

  def install
    system "./bootstrap.sh"
    system "./b2", "--with-atomic", "stage"

    %w[boost_headers Boost].each { |d| rm_rf "stage/lib/cmake/#{d}-#{version}" }
    rm "stage/lib/cmake/BoostDetectToolset-#{version}.cmake"
    prefix.install "stage/lib"
    prefix.install "libs/atomic/include"
  end

  test do
    system "echo"
  end
end
