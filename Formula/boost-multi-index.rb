class BoostMultiIndex < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/multi_index/"
  url "https://github.com/boostorg/multi_index.git",
    tag:      "boost-1.77.0",
    revision: "2bbf21cfc9fd8a782aa445eec178dbc15986e761"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-multi-index-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "ff07aae3320eabf8707480db1832417ca078088b178fcee8346075ca98509e39"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
