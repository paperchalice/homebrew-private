class BoostFunctionTypes < Formula
  desc "Make funciton types better"
  homepage "https://boost.org/libs/function_types/"
  url "https://github.com/boostorg/function_types.git",
    tag:      "boost-1.77.0",
    revision: "895335874d67987ada0d8bf6ca1725e70642ed49"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-function-types-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "edb39b8b72842fde3321b790f6727748542d123dde57561c99de89b1365bee42"
  end

  depends_on "boost-detail"
  depends_on "boost-mpl"

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
