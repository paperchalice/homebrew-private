class BoostInterprocess < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/interprocess/"
  url "https://github.com/boostorg/interprocess.git",
    tag:      "boost-1.77.0",
    revision: "7b2a37e614833f5fc7ab7d10df20aa11bc583bed"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-interprocess-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "77cc3093eb41cc2b2da0d0b257179dfd0a85c47985ff93c84da09710f0deb3e6"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
