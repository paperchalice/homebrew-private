class BoostTuple < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/tuple/"
  url "https://github.com/boostorg/tuple.git",
    tag:      "boost-1.77.0",
    revision: "ec4f3b23c21581656f6241903e723e7fde761993"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-tuple-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "692670f6977f0515010a79c97bcac0e77171bc1d2c48cf55a1867d397ecdd20c"
  end

  depends_on "boost-core"
  depends_on "boost-type-traits"

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
