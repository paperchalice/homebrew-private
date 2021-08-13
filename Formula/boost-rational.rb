class BoostRational < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/rational/"
  url "https://github.com/boostorg/rational.git",
    tag:      "boost-1.77.0",
    revision: "564623136417068916495e2b24737054d607347c"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
