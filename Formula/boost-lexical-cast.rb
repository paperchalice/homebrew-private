class BoostLexicalCast < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/lexical_cast/"
  url "https://github.com/boostorg/lexical_cast.git",
    tag:      "boost-1.77.0",
    revision: "934858fbdc86aead9831e579dc11575c579f577d"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-lexical-cast-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "54ea7e23f2d0fda260e7463e7486f652694fb9fdd609eca3e96704a6ea6068ed"
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
