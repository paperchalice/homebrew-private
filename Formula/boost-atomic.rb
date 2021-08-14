class BoostAtomic < Formula
  desc "Atomic data types and operations"
  homepage "https://boost.org/libs/atomic/"
  url "https://github.com/boostorg/boost.git",
    tag:      "boost-1.77.0",
    revision: "9d3f9bcd7d416880d4631d7d39cceeb4e8f25da0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-atomic-1.77.0"
    rebuild 1
    sha256 cellar: :any, big_sur: "aefbaf7b076b7ac122fa968132fc508d1e3bb4d9d5dfcb8cd45cfbdda72fcfff"
  end

  depends_on "boost-config" => :build

  def install
    system "./bootstrap.sh"
    system "./b2", "--with-atomic", "stage"

    bc = Formula["boost-config"]
    Pathname.glob(bc.lib/"cmake/*").each { |c| rm_rf "stage/lib/cmake/#{c.basename}" }

    prefix.install "stage/lib"
    prefix.install "libs/atomic/include"
  end

  test do
    system "echo"
  end
end
