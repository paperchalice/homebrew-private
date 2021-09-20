class BoostFlyweight < Formula
  desc "Constant access to shared common data"
  homepage "https://boost.org/libs/flyweight/"
  url "https://github.com/boostorg/flyweight.git",
    tag:      "boost-1.77.0",
    revision: "af4fd3e8eb532099cec51bb6f199029b65e7998d"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-flyweight-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "283447fd3762e6eb6fe3c1bf5e60e5739e317a6c293eb4ebb17b9f206574c6bd"
  end

  depends_on "boost-interprocess"
  depends_on "boost-mpl"
  depends_on "boost-multi-index"

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
