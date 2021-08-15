class BoostPolyCollection < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/poly_collection/"
  url "https://github.com/boostorg/poly_collection.git",
    tag:      "boost-1.77.0",
    revision: "0b8bfc4cff012d0f23049fc5a0009ac4abadceb4"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-poly-collection-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "d9ab5c0f72ef482ab52731675e93d0012762dafa305192eb2b2950cd0272a9ec"
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
