class BoostUuid < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/uuid/"
  url "https://github.com/boostorg/uuid.git",
    tag:      "boost-1.77.0",
    revision: "eaa4be7b96c99ad56effc351aa44d0bef04da5a3"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
