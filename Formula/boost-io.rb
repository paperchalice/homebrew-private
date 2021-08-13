class BoostIo < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/io/"
  url "https://github.com/boostorg/io.git",
    tag:      "boost-1.77.0",
    revision: "7392d7274c3743e605bf58076566c258617833ed"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-io-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "3e289562c262ca7d591dc7845efbfa0950233aaca9f2cf830472d67cd94c3f66"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
