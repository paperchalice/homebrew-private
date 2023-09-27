class BoostHana < Formula
  desc "Your standard library for metaprogramming"
  homepage "https://boost.org/libs/hana/"
  url "https://github.com/boostorg/hana.git",
    tag:      "boost-1.77.0",
    revision: "5c28aad03b6e157452d8623802d70dc95a7b57b6"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-hana-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "0335a596d6221c7a33d4776c454ec2d32b8ba4b3d07ef9c73180ec3228b81da6"
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
