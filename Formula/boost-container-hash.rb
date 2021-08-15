class BoostContainerHash < Formula
  desc "Generic hash function for STL style unordered containers"
  homepage "https://boost.org/libs/container_hash/"
  url "https://github.com/boostorg/container_hash.git",
    tag:      "boost-1.77.0",
    revision: "e69c4c830e8999602a966a3405487814d7a50f3d"
  license "BSL-1.0"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
