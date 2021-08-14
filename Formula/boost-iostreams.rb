class BoostIostreams < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/iostreams/"
  url "https://github.com/boostorg/boost.git",
    tag:      "boost-1.77.0",
    revision: "9d3f9bcd7d416880d4631d7d39cceeb4e8f25da0"

  depends_on "boost-config" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "./bootstrap.sh"
    system "./b2", "--with-iostreams", "stage"

    bc = Formula["boost-config"]
    Pathname.glob(bc.lib/"cmake/*").each { |c| rm_rf "stage/lib/cmake/#{c.basename}" }

    prefix.install "stage/lib"
    prefix.install "libs/iostreams/include"
  end

  test do
    system "echo"
  end
end
