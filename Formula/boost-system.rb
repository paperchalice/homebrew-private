class BoostSystem < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/system/"
  url "https://github.com/boostorg/boost.git",
    tag:      "boost-1.77.0",
    revision: "9d3f9bcd7d416880d4631d7d39cceeb4e8f25da0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-system-1.77.0"
    sha256 cellar: :any, big_sur: "a765f0ff4d07883a5ae0af536f27ed272bb6599f56d95db8a9e7aa3728f5937b"
  end

  depends_on "boost-config" => :build

  def install
    system "./bootstrap.sh"
    system "./b2", "--with-system", "stage"

    bc = Formula["boost-config"]
    Pathname.glob(bc.lib/"cmake/*").each { |c| rm_rf "stage/lib/cmake/#{c.basename}" }

    prefix.install "stage/lib"
    prefix.install "libs/system/include"
  end

  test do
    system "echo"
  end
end
