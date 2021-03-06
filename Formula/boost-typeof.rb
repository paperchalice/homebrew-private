class BoostTypeof < Formula
  desc "Get types before language-based facility is added"
  homepage "https://boost.org/libs/typeof/"
  url "https://github.com/boostorg/typeof.git",
    tag:      "boost-1.77.0",
    revision: "46c7a05f826fc020ee88210ea2a5cd9278b930ab"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-typeof-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "872fe7f2c32b612e9b526ffdc766615346e4049d58df91bbf63a7aebfbeb8e00"
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
