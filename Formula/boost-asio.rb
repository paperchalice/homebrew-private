class BoostAsio < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/asio/"
  url "https://github.com/boostorg/asio.git",
    tag:      "boost-1.77.0",
    revision: "71431fcedeaf04be372c9d2c357be164c2742c43"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-asio-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "61db5a065ac54b2c6b953d05e2c4101d1cc8f390528402dc277a8cd0de955196"
  end

  depends_on "boost-align"
  depends_on "boost-algorithm"
  depends_on "boost-assert"
  depends_on "boost-atomic"
  depends_on "boost-bind"
  depends_on "boost-chrono"
  depends_on "boost-concept-check"
  depends_on "boost-container-hash"
  depends_on "boost-context"
  depends_on "boost-coroutine"
  depends_on "boost-detail"
  depends_on "boost-exception"
  depends_on "boost-function"
  depends_on "boost-functional"
  depends_on "boost-iterator"
  depends_on "boost-optional"
  depends_on "boost-predef"
  depends_on "boost-preprocessor"
  depends_on "boost-ratio"
  depends_on "boost-rational"
  depends_on "boost-regex"
  depends_on "boost-scope-exit"
  depends_on "boost-serialization"
  depends_on "boost-smart-ptr"
  depends_on "boost-spirit"
  depends_on "boost-system"
  depends_on "boost-thread"
  depends_on "boost-throw-exception"
  depends_on "boost-tokenizer"
  depends_on "boost-tuple"
  depends_on "boost-type-index"
  depends_on "boost-type-traits"
  depends_on "boost-typeof"
  depends_on "boost-utility"

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
