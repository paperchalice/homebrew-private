class BoostMultiprecision < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/multiprecision/"
  url "https://github.com/boostorg/multiprecision.git",
    tag:      "boost-1.77.0",
    revision: "e7c501f72462e0bf40c3ee4bbde990fc5aa0101c"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
