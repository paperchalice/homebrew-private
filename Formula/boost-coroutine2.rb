class BoostCoroutine2 < Formula
  desc "Templates for generalized subroutines"
  homepage "https://boost.org/libs/coroutine2/"
  url "https://github.com/boostorg/coroutine2.git",
    tag:      "boost-1.77.0",
    revision: "90d319492826972571aa0a7e1a36a46f32d45b70"
  license "BSL-1.0"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
