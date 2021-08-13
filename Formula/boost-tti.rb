class BoostTti < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/tti/"
  url "https://github.com/boostorg/tti.git",
    tag:      "boost-1.77.0",
    revision: "03734c54a51b6372ac3296d2fe5103b7360bcd3f"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
