class BoostUnits < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/units/"
  url "https://github.com/boostorg/units.git",
    tag:      "boost-1.77.0",
    revision: "45787015dd8c11653eb988260acf05c4af9d42e5"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
