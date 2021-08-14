class BoostException < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/exception/"
  url "https://github.com/boostorg/boost.git",
    tag:      "boost-1.77.0",
    revision: "9d3f9bcd7d416880d4631d7d39cceeb4e8f25da0"

  def install
    system "./bootstrap.sh"
    system "./b2", "--with-exception", "stage"

    %w[boost_headers Boost].each { |d| rm_rf "stage/lib/cmake/#{d}-#{version}" }
    rm "stage/lib/cmake/BoostDetectToolset-#{version}.cmake"
    prefix.install "stage/lib"
    prefix.install "libs/exception/include"
  end

  test do
    system "echo"
  end
end
