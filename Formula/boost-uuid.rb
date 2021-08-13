class BoostUuid < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/uuid/"
  url "https://github.com/boostorg/uuid.git",
    tag:      "boost-1.77.0",
    revision: "eaa4be7b96c99ad56effc351aa44d0bef04da5a3"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-uuid-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "b56fdbb175ace6e3c1ce4d853713339eeedc9813d31eb1987fc7cba686ac31b3"
  end

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
