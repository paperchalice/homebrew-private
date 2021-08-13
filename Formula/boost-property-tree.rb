class BoostPropertyTree < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/property_tree/"
  url "https://github.com/boostorg/property_tree.git",
    tag:      "boost-1.77.0",
    revision: "d30ff9404bd6af5cc8922a177865e566f4846b19"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
