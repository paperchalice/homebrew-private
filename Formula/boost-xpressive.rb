class BoostXpressive < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/xpressive/"
  url "https://github.com/boostorg/xpressive.git",
    tag:      "boost-1.77.0",
    revision: "4679fbd23f962bfa78d44acf5fa48f6f790642c0"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-xpressive-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "ed853ba9c881016888e17ac8551f6ee85fb1056b18a1edb5524c629643cf35e2"
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
