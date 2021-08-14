class BoostSerialization < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/serialization/"
  url "https://github.com/boostorg/boost.git",
    tag:      "boost-1.77.0",
    revision: "9d3f9bcd7d416880d4631d7d39cceeb4e8f25da0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-serialization-1.77.0"
    sha256 cellar: :any, big_sur: "435b4c1b365737aad159b68667aea8f1a0bab2605078b243b9784b0efd664cbc"
  end

  depends_on "boost-config" => :build

  def install
    system "./bootstrap.sh"
    system "./b2", "--with-serialization", "stage"

    bc = Formula["boost-config"]
    Pathname.glob(bc.lib/"cmake/*").each { |c| rm_rf "stage/lib/cmake/#{c.basename}" }

    prefix.install "stage/lib"
    prefix.install "libs/serialization/include"
  end

  test do
    system "echo"
  end
end
