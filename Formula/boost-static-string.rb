class BoostStaticString < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/static_string/"
  url "https://github.com/boostorg/static_string.git",
    tag:      "boost-1.77.0",
    revision: "6978da552efcf9a4394c747553ea75f53e3af832"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
