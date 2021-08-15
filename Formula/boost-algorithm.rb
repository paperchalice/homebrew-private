class BoostAlgorithm < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/algorithm/"
  url "https://github.com/boostorg/algorithm.git",
    tag:      "boost-1.77.0",
    revision: "3b3bd8d3db43915c74d574ff36b4d945b6fc7917"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-algorithm-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "7a2ff94f97b1ad309daea8a39b30a2949b11a0b630f4b14f975891001a09de8c"
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
