class BoostFunction < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/function/"
  url "https://github.com/boostorg/function.git",
    tag:      "boost-1.77.0",
    revision: "6d98696d74e1cfbdbe502695cc6b3539b4d4acc9"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
