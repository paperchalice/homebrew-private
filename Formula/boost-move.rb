class BoostMove < Formula
  desc "Move semantics for old compiler"
  homepage "https://boost.org/libs/move/"
  url "https://github.com/boostorg/move.git",
    tag:      "boost-1.77.0",
    revision: "6ab49a8d82909ffa6675325832f3e5f45f1bbb51"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-move-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "0601f5ed2f085f109e2ae2ee47c6b8b604d10ad842c7eed67bc8d48781a48372"
  end

  depends_on "boost-core"
  depends_on "boost-static-assert"

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
