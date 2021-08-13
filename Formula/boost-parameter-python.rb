class BoostParameterPython < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/parameter_python/"
  url "https://github.com/boostorg/parameter_python.git",
    tag:      "boost-1.77.0",
    revision: "787d8d38d9fd49c34a757b20361f8042dd5ac820"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
