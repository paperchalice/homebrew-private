class BoostConceptCheck < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/concept_check/"
  url "https://github.com/boostorg/concept_check.git",
    tag:      "boost-1.77.0",
    revision: "e34c735a1a6902de0d3e20ea58cfd8f101702458"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
