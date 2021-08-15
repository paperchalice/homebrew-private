class BoostMpl < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/mpl/"
  url "https://github.com/boostorg/mpl.git",
    tag:      "boost-1.77.0",
    revision: "341748e4cb534f41fa3d0e34748f2771f5427123"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-mpl-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "04bafe7ee4edaf0195ecc08ea2eeb9fd73c35ca1fa80cd6a52eca4e4a2b6f537"
  end

  depends_on "boost-preprocessor"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
