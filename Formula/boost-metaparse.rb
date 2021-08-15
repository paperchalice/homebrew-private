class BoostMetaparse < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/metaparse/"
  url "https://github.com/boostorg/metaparse.git",
    tag:      "boost-1.77.0",
    revision: "ca629d1438c6ba50a705b2aede918b527caecf7d"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-metaparse-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "750a43bc2445ff2ab3edf2a6700de44d217447c31ffe69a3379eab6147eda0b5"
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
