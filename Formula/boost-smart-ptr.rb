class BoostSmartPtr < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/smart_ptr/"
  url "https://github.com/boostorg/smart_ptr.git",
    tag:      "boost-1.77.0",
    revision: "72221d1da0ada73871ff5e0f8e60fe5ecbd7a296"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
