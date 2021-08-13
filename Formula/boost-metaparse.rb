class BoostMetaparse < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/metaparse/"
  url "https://github.com/boostorg/metaparse.git",
    tag:      "boost-1.77.0",
    revision: "ca629d1438c6ba50a705b2aede918b527caecf7d"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
