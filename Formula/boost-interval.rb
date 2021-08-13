class BoostInterval < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/numeric/interval/"
  url "https://github.com/boostorg/interval.git",
    tag:      "boost-1.77.0",
    revision: "53ba1b16e8353583b3fb77cacac2e322b9b87b25"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-interval-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "b0123c0e01da3139739bdb5d92a1e5d0a474491ed0ff5b5ef13213f0c6aed83a"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end