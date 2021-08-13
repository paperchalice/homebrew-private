class BoostEndian < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/endian/"
  url "https://github.com/boostorg/endian.git",
    tag:      "boost-1.77.0",
    revision: "14dd63931211782a2169c8146e459afe20f92239"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
