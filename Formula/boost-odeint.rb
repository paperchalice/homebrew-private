class BoostOdeint < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/odeint/"
  url "https://github.com/boostorg/odeint.git",
    tag:      "boost-1.77.0",
    revision: "db8f91a51da630957d6bfa1ff87be760b0be97a6"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
