class BoostIcl < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/icl/"
  url "https://github.com/boostorg/icl.git",
    tag:      "boost-1.77.0",
    revision: "e6c06ddee1e2320f11c4ec5cd2661c4abe9bca53"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-icl-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "fffe1fc84914fe017118e8e5f3ab42697671b927fe61d38686c1f57cf8e1dd34"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
