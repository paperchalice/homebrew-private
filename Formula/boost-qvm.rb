class BoostQvm < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/qvm/"
  url "https://github.com/boostorg/qvm.git",
    tag:      "boost-1.77.0",
    revision: "cdc1a96133ef1db9405e0f5a27f4aa9213d627b4"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
