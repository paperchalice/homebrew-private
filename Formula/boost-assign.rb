class BoostAssign < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/assign/"
  url "https://github.com/boostorg/assign.git",
    tag:      "boost-1.77.0",
    revision: "e764ac1ca08daa46b4609a99895fe4874b8dc53b"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-assign-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "2214777c6f14f02c176ee23ec6c0a3cd6d4b550b507816725afbd1f62b1ef9ac"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
