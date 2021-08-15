class BoostSpirit < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/spirit/"
  url "https://github.com/boostorg/spirit.git",
    tag:      "boost-1.77.0",
    revision: "eeb2f2052f4ae7f77bca1bef24916c558832be83"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-spirit-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "ed490f451094abe51dc8666e0899da700fb04782c2f8b2fb6425a028f6d1a575"
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
