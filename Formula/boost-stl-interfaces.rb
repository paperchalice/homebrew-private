class BoostStlInterfaces < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/stl_interfaces/"
  url "https://github.com/boostorg/stl_interfaces.git",
    tag:      "boost-1.77.0",
    revision: "89840c0531e55b21172e4c824ad7bfb58c41e6fb"

  def install
    prefix.install "include"
  end

  test do
    system "echo"
  end
end
