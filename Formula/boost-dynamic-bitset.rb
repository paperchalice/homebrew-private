class BoostDynamicBitset < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/dynamic_bitset/"
  url "https://github.com/boostorg/dynamic_bitset.git",
    tag:      "boost-1.77.0",
    revision: "11d85403b905e8a1b485590dd170fef90d4bd045"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-dynamic-bitset-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "f60aea3cfded88ac00be8822a67b1a2dcc3396da36a24e23ea9ec97c6dc595e7"
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
