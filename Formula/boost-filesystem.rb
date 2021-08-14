class BoostFilesystem < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/filesystem/"
  url "https://github.com/boostorg/boost.git",
    tag:      "boost-1.77.0",
    revision: "9d3f9bcd7d416880d4631d7d39cceeb4e8f25da0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-filesystem-1.77.0"
    sha256 cellar: :any, big_sur: "c7d79af3b484a4994bc44c4fcc39078419d28eb9214213697850983bba0189fb"
  end

  depends_on "boost-config" => :build

  def install
    system "./bootstrap.sh"
    system "./b2", "--with-filesystem", "cxxflags=-std=c++14", "stage"

    bc = Formula["boost-config"]
    Pathname.glob(bc.lib/"cmake/*").each { |c| rm_rf "stage/lib/cmake/#{c.basename}" }

    prefix.install "stage/lib"
    prefix.install "libs/filesystem/include"
  end

  test do
    system "echo"
  end
end
