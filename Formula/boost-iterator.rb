class BoostIterator < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/iterator/"
  url "https://github.com/boostorg/iterator.git",
    tag:      "boost-1.77.0",
    revision: "72a7fb1b7372cf18df331e0ebbfb555f244c03fe"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-iterator-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "32df2237d8c37e34ab488854bda5fde5b62298c63a386ac80c3e59356f2b79f0"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end