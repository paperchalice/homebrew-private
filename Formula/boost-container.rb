class BoostContainer < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/container/"
  url "https://github.com/boostorg/boost.git",
    tag:      "boost-1.77.0",
    revision: "9d3f9bcd7d416880d4631d7d39cceeb4e8f25da0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-container-1.77.0"
    sha256 cellar: :any, big_sur: "d39febc487033334404b8b95c5c47a1c60cee5d3158e520885c707143e2f690d"
  end

  depends_on "boost-config" => :build

  def install
    system "./bootstrap.sh"
    system "./b2", "--with-container", "stage"

    bc = Formula["boost-config"]
    Pathname.glob(bc.lib/"cmake/*").each { |c| rm_rf "stage/lib/cmake/#{c.basename}" }

    prefix.install "stage/lib"
    prefix.install "libs/container/include"
  end

  test do
    system "echo"
  end
end
