class BoostDateTime < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/date_time/"
  url "https://github.com/boostorg/boost.git",
    tag:      "boost-1.77.0",
    revision: "9d3f9bcd7d416880d4631d7d39cceeb4e8f25da0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-date-time-1.77.0"
    sha256 cellar: :any, big_sur: "a3e19a30c035d8c2ad9888556cedcb0e09395481024e8c3085942741b683bd8a"
  end

  depends_on "boost-config" => :build

  def install
    system "./bootstrap.sh"
    system "./b2", "--with-date_time", "stage"

    bc = Formula["boost-config"]
    Pathname.glob(bc.lib/"cmake/*").each { |c| rm_rf "stage/lib/cmake/#{c.basename}" }

    prefix.install "stage/lib"
    prefix.install "libs/date_time/include"
  end

  test do
    system "echo"
  end
end
