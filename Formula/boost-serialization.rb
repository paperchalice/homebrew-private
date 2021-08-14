class BoostSerialization < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/serialization/"
  url "https://github.com/boostorg/boost.git",
    tag:      "boost-1.77.0",
    revision: "9d3f9bcd7d416880d4631d7d39cceeb4e8f25da0"

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
