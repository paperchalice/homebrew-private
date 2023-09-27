class BoostSafeNumerics < Formula
  desc "Replacements to standard numeric types which throw exceptions on errors"
  homepage "https://boost.org/libs/safe_numerics/"
  url "https://github.com/boostorg/safe_numerics.git",
    tag:      "boost-1.77.0",
    revision: "d61e5ad30e96c0652b53ce83c7858c15d322cbbf"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-safe-numerics-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "80f2fa3810ee2ba70ca41ef26c86df3384a5d8cffc852517ee2b0ce0c2a14548"
  end

  depends_on "boost-concept-check"
  depends_on "boost-integer"
  depends_on "boost-logic"
  depends_on "boost-mp11"

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
