class BoostConversion < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/conversion/"
  url "https://github.com/boostorg/conversion.git",
    tag:      "boost-1.77.0",
    revision: "1a2e4fd8efae1d6c5db40e52d553fe56a82299c9"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
