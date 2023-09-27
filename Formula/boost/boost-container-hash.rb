class BoostContainerHash < Formula
  desc "Generic hash function for STL style unordered containers"
  homepage "https://boost.org/libs/container_hash/"
  url "https://github.com/boostorg/container_hash.git",
    tag:      "boost-1.77.0",
    revision: "e69c4c830e8999602a966a3405487814d7a50f3d"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-container-hash-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "8878429c71883531d2b4c9a193de61034e675a5121be2d640c58e2ec2aaf5d03"
  end

  depends_on "boost-detail"
  depends_on "boost-integer"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
