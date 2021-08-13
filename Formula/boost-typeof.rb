class BoostTypeof < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/typeof/"
  url "https://github.com/boostorg/typeof.git",
    tag:      "boost-1.77.0",
    revision: "46c7a05f826fc020ee88210ea2a5cd9278b930ab"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-typeof-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "872fe7f2c32b612e9b526ffdc766615346e4049d58df91bbf63a7aebfbeb8e00"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
