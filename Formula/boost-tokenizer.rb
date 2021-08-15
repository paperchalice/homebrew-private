class BoostTokenizer < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/tokenizer/"
  url "https://github.com/boostorg/tokenizer.git",
    tag:      "boost-1.77.0",
    revision: "f0857f042d96b5dd04ad5c2561f7006cddbdcde5"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-tokenizer-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "0fae1999ecba641910651298beedbb09c4a0f36bd0da22c4a55668e75fdd9be8"
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
