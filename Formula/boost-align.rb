class BoostAlign < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/align/"
  url "https://github.com/boostorg/align.git",
    tag:      "boost-1.77.0",
    revision: "0790cd45c8e05b1b59fffbc948b6bcb26eb6a2aa"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
