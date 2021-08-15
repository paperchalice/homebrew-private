class BoostBeast < Formula
  desc "Awesome library from Boost"
  homepage "https://boost.org/libs/beast/"
  url "https://github.com/boostorg/beast.git",
    tag:      "boost-1.77.0",
    revision: "710cc53331f197f6f17e8c38454c09df68e43c03"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/paperchalice/homebrew-private/releases/download/boost-beast-1.77.0"
    sha256 cellar: :any_skip_relocation, big_sur: "e7ae27bd70c79d11b28468784607dad75734fdc576ae9a9d09afcd8474b17bb4"
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
