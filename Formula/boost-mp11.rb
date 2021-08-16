class BoostMp11 < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/mp11/"
  url "https://github.com/boostorg/mp11.git",
    tag:      "boost-1.77.0",
    revision: "9d43d1f69660617266c9168e6e121ab2b0ea2287"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-mp11-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "7a5e2da642d045830648b672974527248aa375e707e43f9563853a23aacc2fa0"
  end

  depends_on "boost-core"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
