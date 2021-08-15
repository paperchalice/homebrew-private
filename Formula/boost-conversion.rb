class BoostConversion < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/conversion/"
  url "https://github.com/boostorg/conversion.git",
    tag:      "boost-1.77.0",
    revision: "1a2e4fd8efae1d6c5db40e52d553fe56a82299c9"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-conversion-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "17a7b51ec816e12a9bda2238479ebb386e734f9948f12e451908a39f7908055c"
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
