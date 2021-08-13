class BoostPolygon < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/polygon/"
  url "https://github.com/boostorg/polygon.git",
    tag:      "boost-1.77.0",
    revision: "8ba35b57c1436c4b36f7544aadd78c2b24acc7db"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
