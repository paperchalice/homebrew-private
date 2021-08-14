class BoostNowide < Formula
  desc "Make cross platform Unicode aware programming easier"
  homepage "https://boost.org/libs/nowide/"
  url "https://github.com/boostorg/boost.git",
    tag:      "boost-1.77.0",
    revision: "9d3f9bcd7d416880d4631d7d39cceeb4e8f25da0"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-nowide-1.77.0"
    rebuild 1
    sha256 cellar: :any, big_sur: "41677d007e3a4b3f246b4f879fc91c32857a19610d8400f0372d46e2fb0d1326"
  end

  depends_on "boost-config" => :build

  def install
    system "./bootstrap.sh"
    system "./b2", "--with-nowide", "cxxflags=-std=c++14", "stage"

    bc = Formula["boost-config"]
    Pathname.glob(bc.lib/"cmake/*").each { |c| rm_rf "stage/lib/cmake/#{c.basename}" }

    prefix.install "stage/lib"
    prefix.install "libs/nowide/include"
  end

  test do
    system "echo"
  end
end
