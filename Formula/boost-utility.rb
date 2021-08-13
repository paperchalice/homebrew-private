class BoostUtility < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/utility/"
  url "https://github.com/boostorg/utility.git",
    tag:      "boost-1.77.0",
    revision: "375382e1e6c677c7849e894675251db353ab9186"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
