class BoostInterval < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/interval/"
  url "https://github.com/boostorg/interval.git",
    tag:      "boost-1.77.0",
    revision: "53ba1b16e8353583b3fb77cacac2e322b9b87b25"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
