class BoostContext < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/context/"
  url "https://github.com/boostorg/boost.git",
    tag:      "boost-1.77.0",
    revision: "9d3f9bcd7d416880d4631d7d39cceeb4e8f25da0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-context-1.77.0"
    sha256 cellar: :any, big_sur: "f674f60150efbbff54a086e370ee6fcf2eaa18782afa0c80ac58c9994d026892"
  end

  depends_on "boost-config" => :build

  def install
    system "./bootstrap.sh"
    system "./b2", "--with-context", "stage"

    bc = Formula["boost-config"]
    Pathname.glob(bc.lib/"cmake/*").each { |c| rm_rf "stage/lib/cmake/#{c.basename}" }

    prefix.install "stage/lib"
    prefix.install "libs/context/include"
  end

  test do
    system "echo"
  end
end
