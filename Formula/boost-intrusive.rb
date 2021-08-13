class BoostIntrusive < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/intrusive/"
  url "https://github.com/boostorg/intrusive.git",
    tag:      "boost-1.77.0",
    revision: "f44b0102b4ee9acf7b0304b3f5b27dde02297202"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
