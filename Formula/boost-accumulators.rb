class BoostAccumulators < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/accumulators/"
  url "https://github.com/boostorg/accumulators.git",
    tag:      "boost-1.77.0",
    revision: "14c13370602fe86d134a948943958cab0921ce9c"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-accumulators-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "42a3b13709ef85b159ba67e7cddbb4b8939ce2df42d551e46503a34146c6da08"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
