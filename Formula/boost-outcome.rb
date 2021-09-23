class BoostOutcome < Formula
  desc "Provides very lightweight outcome<T> and result"
  homepage "https://boost.org/libs/outcome/"
  url "https://github.com/boostorg/outcome.git",
    tag:      "boost-1.77.0",
    revision: "e9439030d49c2d70391d8a74509dfcdbcea3881e"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-outcome-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "f30bbe2cb8583585316a01ec445d69fa081571f937c3ae7ea11353ed6658a5f5"
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
