class BoostNumericConversion < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/numeric_conversion/"
  url "https://github.com/boostorg/numeric_conversion.git",
    tag:      "boost-1.77.0",
    revision: "db44689f4f4f74d6572a868e13f523c82fca5a55"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
