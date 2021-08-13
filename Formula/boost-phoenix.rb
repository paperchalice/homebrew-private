class BoostPhoenix < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/phoenix/"
  url "https://github.com/boostorg/phoenix.git",
    tag:      "boost-1.77.0",
    revision: "15500aec2187ab59e51d05addab0fdba7e788dbb"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-phoenix-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "5ec41649ffc527ffda697e9876836f1490bb5815e4575683c4861e1099e89a9a"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
