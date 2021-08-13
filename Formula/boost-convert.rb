class BoostConvert < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/convert/"
  url "https://github.com/boostorg/convert.git",
    tag:      "boost-1.77.0",
    revision: "d5f7347d309d222d10e7a204ddd086e7d6c64b21"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-convert-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "a453a3c1494efd466ec3ec3f2923befa81ff7146ec247ee1c5ab767855e6bcc5"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end