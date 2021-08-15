class BoostStlInterfaces < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/stl_interfaces/"
  url "https://github.com/boostorg/stl_interfaces.git",
    tag:      "boost-1.77.0",
    revision: "89840c0531e55b21172e4c824ad7bfb58c41e6fb"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-stl-interfaces-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "0ad51a15e515e54f76d8bd78627149e2757af84971595b3aaae2199394132e82"
  end

  def install
    prefix.install "include"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      int main() {
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++14", "test.cpp"
    system "./a.out"
  end
end
