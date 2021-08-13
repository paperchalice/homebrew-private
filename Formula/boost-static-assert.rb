class BoostStaticAssert < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/static_assert/"
  url "https://github.com/boostorg/static_assert.git",
    tag:      "boost-1.77.0",
    revision: "392199f6b14ee64260afde27a1c3f876c4bd4843"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
