class BoostPredef < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/predef/"
  url "https://github.com/boostorg/predef.git",
    tag:      "boost-1.77.0",
    revision: "e3a87328f415c61766838e1f5367885251b46e93"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-predef-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "457d2c068d7d5f95ec266268ef129e4000b671252bf119abf7c3f227b9c602db"
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
