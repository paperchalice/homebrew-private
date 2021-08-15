class BoostCoroutine2 < Formula
  desc "Templates for generalized subroutines"
  homepage "https://boost.org/libs/coroutine2/"
  url "https://github.com/boostorg/coroutine2.git",
    tag:      "boost-1.77.0",
    revision: "90d319492826972571aa0a7e1a36a46f32d45b70"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-coroutine2-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "b40a469d9e9caa9696009a024b6d1f6176d56f0f1a00c72bfef39c0a774ce8f1"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
