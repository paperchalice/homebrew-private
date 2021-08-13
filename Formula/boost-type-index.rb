class BoostTypeIndex < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/type_index/"
  url "https://github.com/boostorg/type_index.git",
    tag:      "boost-1.77.0",
    revision: "a3c6a957eeaf1612eb34b013ec13e67d4c279a41"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-type-index-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "8435c281b378c1910965298e62629ae73b8499e8539ad77623dc43cc8705b8c8"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
