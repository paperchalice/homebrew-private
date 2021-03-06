class BoostAny < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/any/"
  url "https://github.com/boostorg/any.git",
    tag:      "boost-1.77.0",
    revision: "ab9349aaa419b9ea53b5bc5cbe633690b376b8f5"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-any-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "bcd02b374b86ce1741b6cbe12fff4aec089d53f23e2a0e692dd3129c175ee91c"
  end

  depends_on "boost-type-index"

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
