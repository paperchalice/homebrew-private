class BoostSignals2 < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/signals2/"
  url "https://github.com/boostorg/signals2.git",
    tag:      "boost-1.77.0",
    revision: "4a51d6e47230123d413cbecb19eb94f195301b8e"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
