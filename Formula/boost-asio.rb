class BoostAsio < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/asio/"
  url "https://github.com/boostorg/asio.git",
    tag:      "boost-1.77.0",
    revision: "71431fcedeaf04be372c9d2c357be164c2742c43"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-asio-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "61db5a065ac54b2c6b953d05e2c4101d1cc8f390528402dc277a8cd0de955196"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
