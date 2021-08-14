class BoostException < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/exception/"
  url "https://github.com/boostorg/boost.git",
    tag:      "boost-1.77.0",
    revision: "9d3f9bcd7d416880d4631d7d39cceeb4e8f25da0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-exception-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "ffc65ee958691a92c12eb2a5e584f19ae2ce84bdafee0edb33a4c31004faecf9"
  end

  depends_on "boost-config" => :build

  def install
    system "./bootstrap.sh"
    system "./b2", "--with-exception", "stage"

    bc = Formula["boost-config"]
    Pathname.glob(bc.lib/"cmake/*").each { |c| rm_rf "stage/lib/cmake/#{c.basename}" }

    prefix.install "stage/lib"
    prefix.install "libs/exception/include"
  end

  test do
    system "echo"
  end
end
