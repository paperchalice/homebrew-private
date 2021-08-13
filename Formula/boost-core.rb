class BoostCore < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/core/"
  url "https://github.com/boostorg/core.git",
    tag:      "boost-1.77.0",
    revision: "f4b3d5dba6f86caaf96e45901655a954b2ff68b4"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-core-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "f555800aec628fd1c6cff6f66ada092202d42d8c8158b07bccf799570adf9578"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
