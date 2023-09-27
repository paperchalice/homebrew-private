class BoostConceptCheck < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/concept_check/"
  url "https://github.com/boostorg/concept_check.git",
    tag:      "boost-1.77.0",
    revision: "e34c735a1a6902de0d3e20ea58cfd8f101702458"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-concept-check-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "815bf1d5ce456796a9e312ef95b5a9c72ba8d5c815438956d1989bf7b359537f"
  end

  depends_on "boost-preprocessor"
  depends_on "boost-type-traits"

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
