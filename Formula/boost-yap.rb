class BoostYap < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/yap/"
  url "https://github.com/boostorg/yap.git",
    tag:      "boost-1.77.0",
    revision: "262624ac36652d1354e6b2ee38a79f2bc9a66cae"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-yap-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "72db677efcaefbf53c23debefc12d144af20c5b5d0b0107874fcda28807bee11"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
