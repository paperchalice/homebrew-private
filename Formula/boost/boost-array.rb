class BoostArray < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/array/"
  url "https://github.com/boostorg/array.git",
    tag:      "boost-1.77.0",
    revision: "63f83dc350b654172ad04cc719daea0f3643f83c"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-array-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "f2e13751ac0005d954c33a4ef98207cd0291e75878ee1e77f613abe9c68b34ce"
  end

  depends_on "boost-core"
  depends_on "boost-static-assert"
  depends_on "boost-throw-exception"

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
