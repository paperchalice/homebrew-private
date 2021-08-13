class BoostLogic < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/logic/"
  url "https://github.com/boostorg/logic.git",
    tag:      "boost-1.77.0",
    revision: "a5b56ff6fe7368e5f5ebbb374279ddc9fb49a2d5"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
