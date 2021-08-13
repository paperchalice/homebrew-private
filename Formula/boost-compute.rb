class BoostCompute < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/compute/"
  url "https://github.com/boostorg/compute.git",
    tag:      "boost-1.77.0",
    revision: "36c89134d4013b2e5e45bc55656a18bd6141995a"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-compute-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "4cc11a0297942513ad25ea34e1f67833ff4efcc553d8e64a24fc2ac5034345b7"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
