class BoostTypeTraits < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/type_traits/"
  url "https://github.com/boostorg/type_traits.git",
    tag:      "boost-1.77.0",
    revision: "bfce306637e2a58af4b7bbc881a919dafb7d195b"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
