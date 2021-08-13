class BoostLockfree < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/lockfree/"
  url "https://github.com/boostorg/lockfree.git",
    tag:      "boost-1.77.0",
    revision: "66f66c977038cb8a316bfc242de1843df9302613"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
