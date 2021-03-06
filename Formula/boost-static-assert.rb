class BoostStaticAssert < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/static_assert/"
  url "https://github.com/boostorg/static_assert.git",
    tag:      "boost-1.77.0",
    revision: "392199f6b14ee64260afde27a1c3f876c4bd4843"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-static-assert-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "d9b2d26b91d423626a4eece882982a355c594406b6b1d133f0b765d61720cabc"
  end

  depends_on "boost-config"

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
