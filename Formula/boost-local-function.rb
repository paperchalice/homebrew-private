class BoostLocalFunction < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/local_function/"
  url "https://github.com/boostorg/local_function.git",
    tag:      "boost-1.77.0",
    revision: "bbe7bf9e997c674195a59f8f628c0cef45c6166c"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
