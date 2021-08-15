class BoostForeach < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/foreach/"
  url "https://github.com/boostorg/foreach.git",
    tag:      "boost-1.77.0",
    revision: "cc2f75ae30492b9de69b3b692f5c59afcb7dea5e"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-foreach-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "c0165ab5720915642257f784c6cdc45561720b5a3c83944efa16c781d3c0cb39"
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
