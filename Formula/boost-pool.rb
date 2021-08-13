class BoostPool < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/pool/"
  url "https://github.com/boostorg/pool.git",
    tag:      "boost-1.77.0",
    revision: "b516ac5b82571902ced902394b30d38b7d8182f0"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
